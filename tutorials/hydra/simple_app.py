import hydra
from omegaconf import DictConfig, OmegaConf
import logging

def print_function():
    logging.info("This is a simple function that prints a message.")

@hydra.main(version_base=None, config_path="conf", config_name="config")
def my_app(cfg: DictConfig) -> None:
    print_function()
    logging.info(OmegaConf.to_yaml(cfg))

if __name__ == "__main__":
    my_app()