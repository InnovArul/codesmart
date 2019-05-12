import os, sys
from yacs.config import CfgNode as CN

_C = CN()
_C.DATASET = "cuhk03"
_C.GPU_DEVICES = [0, 1]
_C.WORKERS = 4
_C.WIDTH = 112
_C.HEIGHT = 224
_C.ARCH = "resnet50"
_C.SAVE_DIR = "resnet50_model"
_C.SAVE_PREFIX = "resnet50_model"
_C.SEED = 42
_C.EVALUATE = False


_C.TRAIN = CN()
_C.TRAIN.BATCH_SIZE = 32
_C.TRAIN.MAX_EPOCHS = 80
_C.TRAIN.START_EPOCH = 0
_C.TRAIN.LR = 0.001
_C.TRAIN.GAMMA = 0.001
_C.TRAIN.LR = 0.1
_C.TRAIN.WEIGHT_DECAY = 5e-04
_C.TRAIN.MARGIN = 0.3
_C.TRAIN.SAVE_STEP = 50
_C.TRAIN.PRINT_FREQ = 50
_C.TRAIN.PRETRAINED_MODEL = ""

_C.TEST = CN()
_C.TEST.BATCH_SIZE = 32
_C.TEST.POOL = "mean"
_C.TEST.PRETRAINED_MODEL = ""

# print(_C)


def get_cfg_defaults():
    """Get a yacs CfgNode object with default values for my_project."""
    # Return a clone so that the defaults will not be altered
    # This is for the "local variable" use pattern
    return _C.clone()


cfg = _C
# Alternatively, provide a way to import the defaults as
# a global singleton:
# cfg = _C  # users can `from config import cfg`
