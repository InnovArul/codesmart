import gymnasium as gym
import numpy as np
import matplotlib.pyplot as plt
from loguru import logger as logging

import torch
from torchrl.envs import GymEnv, TransformedEnv
from torchrl.envs.transforms import Compose, Resize, ToTensorImage
from tensordict.tensordict import TensorDict

from segment_anything import sam_model_registry, SamAutomaticMaskGenerator
import cv2
import kornia as K
import imageio

DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")

from ai2thor.controller import Controller

def get_ai_thor_controller(floor_plan: str = "FloorPlan1", H: int = 512, W: int = 512):
    # Initialize AI2-THOR controller
    controller = Controller(scene=floor_plan, width=W, height=H, renderDepthImage=False, renderSegmentationImage=False, renderClassImage=False)
    event = controller.step(dict(action="Initialize"))
    return controller, event


# wget https://huggingface.co/datasets/Gourieff/ReActor/resolve/main/models/sams/sam_vit_b_01ec64.pth
def get_sam_model(model_type: str = "vit_b", checkpoint_path: str = "sam_vit_b_01ec64.pth"):
    sam_model = sam_model_registry[model_type](checkpoint=checkpoint_path)
    sam_model.to(DEVICE)
    mask_generator = SamAutomaticMaskGenerator(sam_model,
                                                # pred_iou_thresh=0.5,          # default 0.88
                                                # stability_score_thresh=0.5,   # default 0.95
                                                # points_per_side=16            # increases sampling resolution)
    )
    return mask_generator


def show_top_n_masks(image, masks, n=5, alpha=0.3):
    if len(masks) == 0:
        print("No masks found")
        return

    # Sort masks by area (largest first)
    masks_sorted = sorted(masks, key=lambda x: x['area'], reverse=True)[:n]

    plt.figure(figsize=(10,10))
    plt.imshow(image)

    h, w = masks_sorted[0]['segmentation'].shape
    overlay = np.zeros((h, w, 4))

    for ann in masks_sorted:
        mask = ann['segmentation']
        color = np.random.random(3)
        overlay[mask] = [*color, alpha]

    plt.imshow(overlay)
    plt.axis('off')
    plt.title(f"Top {n} SAM Masks")
    plt.show()
    plt.close("all")


if __name__ == "__main__":
    # gpu availability
    logging.info(f"Using device: {DEVICE}")

    W, H = 256, 256  # desired width and height

    # transform pipeline
    transform = Compose(
        ToTensorImage(from_int=True),
        Resize(w=W, h=H),
    )

    base_env = GymEnv(env_name="CarRacing-v3", from_pixels=True, render_mode="rgb_array", device=DEVICE)
    env = TransformedEnv(base_env=base_env, transform=transform)
    td = env.reset()
    print(td)

    # display a frame
    sam_mask_generator = get_sam_model(model_type="vit_b", checkpoint_path="sam_vit_b_01ec64.pth")
    controller, event = get_ai_thor_controller(floor_plan="FloorPlan1", H=H, W=W)
    actions = ["MoveAhead", "MoveBack", "RotateRight", "RotateLeft", "LookUp", "LookDown"]

    for step in range(20):
        action = np.random.choice(actions)
        event = controller.step(dict(action=action))
        logging.info(f"Step {step}: Action: {action}")

        # pixels = td["pixels"]
        # pixels = torch.tensor(event.frame.copy()).permute(2, 0, 1).to(DEVICE) / 255.0  # Normalize to [0, 1]
        image = event.frame  # HWC, uint8
        samH, samW = image.shape[:2]
        masks = sam_mask_generator.generate(image)
        print(f"Generated {len(masks)} masks.")

        show_top_n_masks(image, masks, n=5)

