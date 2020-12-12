import os, sys
import spatial_correlation_sampler as scs
import torch
import torch.nn as nn
import torch.nn.functional as F
import argparse, time
from tqdm import tqdm

def scs_correlation(input1, input2, P, K=1, dilation_K=1, dilation_P=1):
    out = scs.spatial_correlation_sample(input1, input2, patch_size=P,)
    return out

def unfold_correlation(input1, input2, K=1, dilation=1):
      batch, c, h, w = input2.shape
      temp = F.unfold(input2, kernel_size=K, padding=K//2, dilation=dilation)
      temp = temp.view(batch,c,K,K,h,w)
      input1 = input1.view(batch, c, 1, 1, h, w)
      out = (input1 * temp).sum(dim=1)
      return out

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="SCS analysis")
    parser.add_argument("--height", type=int, default=25)
    parser.add_argument("--width", type=int, default=35)
    parser.add_argument("--channels", type=int, default=128)
    parser.add_argument("--batch", type=int, default=10)
    parser.add_argument("--patch", type=int, default=3)
    parser.add_argument("--times", type=int, default=100)
    parser.add_argument("--dilation", type=int, default=1)

    args = parser.parse_args()

    input1 = torch.randn(args.batch, args.channels, args.height, args.width).cuda()
    input2 = torch.randn(args.batch, args.channels, args.height, args.width).cuda()

    scs_out = scs_correlation(input1, input2, P=args.patch, dilation_P=args.dilation)
    unfold_out = unfold_correlation(input1, input2, K=args.patch, dilation=args.dilation)
    print("diff", torch.sum((scs_out - unfold_out)**2))
    print(scs_out[0,:,:,5,2], "\n", unfold_out[0,:,:,5,2])

    start = time.time()
    for i in tqdm(range(args.times)):
        scs_out = scs_correlation(input1, input2, P=args.patch, dilation_P=args.dilation)
    end = time.time()
    print("scs", (end-start) / args.times)

    start = time.time()
    for i in tqdm(range(args.times)):
        unfold_out = unfold_correlation(input1, input2, K=args.patch, dilation=args.dilation)
    end = time.time()
    print("unfold", (end-start) / args.times)

    #diff = ((scs_out - unfold_out)**2).sum()
    #print("error", diff, scs_out[:,:,:,7,7], unfold_out[:,:,:,7,7])
