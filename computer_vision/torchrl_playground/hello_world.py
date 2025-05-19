
import time
import matplotlib.pyplot as plt
from torchrl.envs import GymEnv, StepCounter, TransformedEnv
from tensordict.nn import TensorDictModule as TensorDict, TensorDictSequential as Seq
from torchrl.modules import EGreedyModule, MLP, QValueModule
from torchrl.objectives import DQNLoss, SoftUpdate
from torchrl.collectors import SyncDataCollector
from torchrl.data import LazyTensorStorage, ReplayBuffer
from torch.optim import Adam
from torchrl._utils import logger as torchrl_logger

# hyperparameters
INIT_RAND_STEPS = 5000 
FRAMES_PER_BATCH = 100
OPTIM_STEPS = 10
EPS_0 = 0.5
BUFFER_LEN = 100_000
ALPHA = 0.05
TARGET_UPDATE_EPS = 0.95
REPLAY_BUFFER_SAMPLE = 128
LOG_EVERY = 1000
MLP_SIZE = 64

if __name__ == "__main__":
    # setup the environment and wrap with step counter
    env = GymEnv("CartPole-v1", device="gpu", seed=0)
    env = TransformedEnv(env, StepCounter())

