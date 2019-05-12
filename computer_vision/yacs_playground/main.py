import os, sys
from config import cfg

cfg_file = "./experiments/exp0.yaml"
cfg.merge_from_file(cfg_file)
print(cfg)
