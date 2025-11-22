import cv2
import torch
import matplotlib.pyplot as plt
from segment_anything import sam_model_registry, SamAutomaticMaskGenerator

# -----------------------------
# CONFIG
# -----------------------------
IMAGE_PATH = "/home/innov/Downloads/sam-v2-ip.png"      # change this
SAM_CHECKPOINT = "sam_vit_b_01ec64.pth"  # path to your SAM checkpoint
MODEL_TYPE = "vit_b"               # vit_b, vit_l or vit_h

DEVICE = "cuda" if torch.cuda.is_available() else "cpu"

# -----------------------------
# 1. Read image (DO NOT normalize)
# -----------------------------
image_bgr = cv2.imread(IMAGE_PATH)
image_rgb = cv2.cvtColor(image_bgr, cv2.COLOR_BGR2RGB)

print("Image shape:", image_rgb.shape)
print("dtype:", image_rgb.dtype)

# -----------------------------
# 2. Load SAM model
# -----------------------------
sam = sam_model_registry[MODEL_TYPE](checkpoint=SAM_CHECKPOINT)
sam.to(device=DEVICE)

mask_generator = SamAutomaticMaskGenerator(
    sam,
    # pred_iou_thresh=0.9,
    # stability_score_thresh=0.9,
#     points_per_side=32
    box_nms_thresh=0.005
 )

# -----------------------------
# 3. Generate masks
# -----------------------------
masks = mask_generator.generate(image_rgb)
print("Number of masks:", len(masks))

# -----------------------------
# 4. Visualize masks
# -----------------------------
plt.figure(figsize=(10,10))
plt.imshow(image_rgb)

for mask in masks:
    segmentation = mask["segmentation"]
    plt.imshow(segmentation, alpha=0.1)

plt.axis("off")
plt.title(f"SAM Masks: {len(masks)} found")
plt.show(block=True)