import torch
from spatial_correlation_sampler import spatial_correlation_sample


def run_spatial_corr(rank):
    corr = spatial_correlation_sample(torch.ones(1, 2, 5, 5), #.to(f"cuda:0"),
                                      torch.ones(1, 2, 5, 5).to(f"cuda:{rank}"))
    print(corr, corr.mean())

#run_spatial_corr(0)
run_spatial_corr(1)
