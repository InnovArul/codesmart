import torch
import numpy as np
import matplotlib.pyplot as plt
from torchrl.envs.transforms import Compose, Resize, ToTensorImage
from torchrl.envs import TransformedEnv, GymEnv

# determine device
DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print("Using device:", DEVICE)

def create_gym_env(env_name: str = "CarRacing-v3", height: int = 256, width: int = 256) -> TransformedEnv:
    base_env = GymEnv(env_name, from_pixels=True, pixels_only=True, device=DEVICE)
    transform = Compose(
        ToTensorImage(from_int=True),
        Resize(h=height, w=width),
    )
    transformed_env = TransformedEnv(base_env, transform)
    return transformed_env

if __name__ == "__main__":
    # create base environment
    env = create_gym_env()
    td = env.reset()
    print("Initial time step:", td)

    # print pixels statistics
    pixels = td["pixels"]
    print("Pixels shape:", pixels.shape)
    print("Pixels dtype:", pixels.dtype)
    print("Pixels min/max:", pixels.min().item(), pixels.max().item())
