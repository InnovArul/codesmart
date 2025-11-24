import torch
import matplotlib.pyplot as plt
from torchrl.envs import GymEnv, TransformedEnv, ParallelEnv
from torchrl.envs.transforms import Compose, ToTensorImage, Resize, Transform

DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")

class SimpleMaskChannel(Transform):
    def __init__(self, in_key="pixels", out_key="pixels"):
        super().__init__(in_keys=[in_key], out_keys=[out_key])
        self.in_key = in_key
        self.out_key = out_key
    
    def _reset(self, tensordict, tensordict_reset):
        return self._call(tensordict_reset)

    def _call(self, tensordict):
        pixels = tensordict[self.in_key]
        gray = pixels.mean(dim=-3, keepdim=True)
        mask = (gray > 0.5).float()
        new_pixels = torch.cat([pixels, mask], dim=-3)
        tensordict[self.out_key] = new_pixels
        return tensordict
    
    def transform_observation_spec(self, observation_spec):
        # Update the observation spec to reflect the new channel count
        if self.in_key in observation_spec:
            spec = observation_spec[self.in_key]
            new_shape = list(spec.shape)
            new_shape[-3] = new_shape[-3] + 1  # Add one channel
            observation_spec[self.out_key] = spec.clone()
            observation_spec[self.out_key].shape = torch.Size(new_shape)
        return observation_spec

def make_transformed_env():
    base_env = GymEnv("CarRacing-v3", from_pixels=True, device=DEVICE)
    tr = Compose(
        ToTensorImage(from_int=True),
        Resize(84, 84),
        SimpleMaskChannel()
    )
    return TransformedEnv(base_env, tr)

if __name__ == "__main__":
    # Use ParallelEnv with 2 environments
    env = ParallelEnv(2, make_transformed_env)
    td = env.reset()
    print("After reset - td['pixels'].shape:", td["pixels"].shape)
    
    # Take first step
    action = env.action_spec.rand()
    td = env.step(td.update({"action": action}))
    print("\nAfter step 1 - td['pixels'].shape:", td["pixels"].shape)
    print("After step 1 - td['next']['pixels'].shape:", td["next"]["pixels"].shape)
    
    # Take second step
    td_next = td["next"]
    action = env.action_spec.rand()
    td = env.step(td_next.update({"action": action}))
    print("\nAfter step 2 - td['pixels'].shape:", td["pixels"].shape)
    print("After step 2 - td['next']['pixels'].shape:", td["next"]["pixels"].shape)
