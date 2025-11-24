import torch
import torch.nn as nn
from torchrl.modules import ProbabilisticActor, TanhNormal
from tensordict.nn import TensorDictModule
from torchrl.envs import GymEnv, TransformedEnv, ParallelEnv
from torchrl.envs.transforms import Compose, ToTensorImage, Resize
from step2_mask_channel import SimpleMaskChannel
    
DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")

class CarRacingCNN(nn.Module):
    def __init__(self, in_channels=4, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)

        self.net = nn.Sequential(
            nn.Conv2d(in_channels=in_channels, out_channels=32, kernel_size=8, stride=4),  # Adjusted in_channels
            nn.ReLU(),
            nn.Conv2d(in_channels=32, out_channels=64, kernel_size=4, stride=2),
            nn.ReLU(),
            nn.Conv2d(in_channels=64, out_channels=64, kernel_size=3, stride=1),
            nn.ReLU(),
            nn.Flatten(),
        )

        with torch.no_grad():
            dummy_input = torch.zeros(1, in_channels, 84, 84)
            n_flatten = self.net(dummy_input).shape[-1]

        self.mu = nn.Linear(n_flatten, 3)
        self.log_std = nn.Linear(n_flatten, 3)
    
    def forward(self, data):
        x = self.net(data)

        if data.ndim == 3:
            x = x.view(-1)

        mu = self.mu(x)
        log_std = self.log_std(x).clamp(-20, 2)
        return mu, log_std


def create_env(env_name="CarRacing-v3", height=84, width=84):

    base_env = GymEnv(env_name, from_pixels=True, device=DEVICE)
    tr = Compose(
        ToTensorImage(from_int=True),
        Resize(height, width),
        SimpleMaskChannel()
    )
    return TransformedEnv(base_env, tr)


if __name__ == "__main__":
    # actor module
    actor_module = TensorDictModule(
        CarRacingCNN(in_channels=4),
        in_keys=["pixels"],
        out_keys=["loc", "scale"],
    )

    env = ParallelEnv(2, create_env)

    actor = ProbabilisticActor(
        module = actor_module,
        spec = env.action_spec,
        in_keys = ["loc", "scale"],
        distribution_class = TanhNormal,
        return_log_prob = True,
    )

    actor = actor.to(DEVICE)

    td = env.reset()
    print("After reset - td['pixels'].shape:", td["pixels"].shape)
    td = actor(td)
    print("After actor - td['action'].shape:", td["action"].shape)