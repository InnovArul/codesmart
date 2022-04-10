from typing import no_type_check
import torch
import torch.autograd as ag
import torch.nn.functional as F
import torch.nn as nn
from einops import rearrange, reduce, repeat
import numpy as np

class MyConv(ag.Function):
    """
    Manual implementation of forward & backward passes of 2D convolution operation
    """

    @staticmethod
    def forward(ctx, input, weights, bias):
        """
        input = b,c,h,w
        w = o,i,h,w
        b = o
        """
        kernel_size = weights.shape[-2:]
        b,c,h,w = input.shape

        # unfold input for convolve operation
        unfold_input = F.unfold(input, kernel_size=kernel_size, dilation=1, padding=kernel_size[0]//2, stride=1)
        unfold_input = rearrange(unfold_input, 'b (c kh kw) hw -> b c kh kw hw', c=c, kh=kernel_size[0], kw=kernel_size[1])

        # multiply input and weights
        out = torch.einsum('bihwm,oihw->bom', unfold_input, weights)

        # add with bias
        out = rearrange(out, 'b o (h w) -> b o h w', h=h, w=w) + rearrange(bias, 'o -> 1 o 1 1')
        ctx.save_for_backward(input, weights, bias, out)
        return out

    @staticmethod
    def backward(ctx, grad_output):
        input, weights, bias, out = ctx.saved_tensors
        
        out_channels, in_channels, kernel_size, _ = weights.shape
        b,c,h,w = input.shape

        # grad_bias depends on only grad_output
        grad_bias = reduce(grad_output, "b oc h w -> oc", reduction='sum')

        # grad_weight depends on input and grad_output
        # unfold input for grad weight calculation
        unfold_input = F.unfold(input, kernel_size=kernel_size, dilation=1, padding=kernel_size//2, stride=1)
        unfold_input = rearrange(unfold_input, 'b (in_channels kh kw) (h w) -> b in_channels kh kw h w', in_channels=in_channels, kh=kernel_size, kw=kernel_size, h=h, w=w)
        grad_weight = torch.einsum('bipqhw,bohw->oipq', unfold_input, grad_output) # p, q = kernel sizes | h,w = input & output height, width

        # grad_input depends on weights and grad_output
        # unfold grad output for grad input calculation
        unfold_gradout = F.unfold(grad_output, kernel_size=kernel_size, dilation=1, padding=kernel_size//2, stride=1)
        unfold_gradout = rearrange(unfold_gradout, 'b (out_channels kh kw) (h w) -> b out_channels kh kw h w', out_channels=out_channels, kh=kernel_size, kw=kernel_size, h=h, w=w)
        weights_for_gradinput = weights.flip(dims=[2,3])
        grad_input = torch.einsum('oipq,bopqhw->bihw', weights_for_gradinput, unfold_gradout) # p, q = kernel sizes | h,w = input & output height, width

        return grad_input, grad_weight, grad_bias


Conv2D = MyConv.apply

if __name__ == "__main__":
    torch.manual_seed(28)
    in_channels = 3
    out_channels = 10
    h, w = 8,8

    # numpy inputs
    npinp = np.random.randn(1, in_channels, h, w)
    npweights = np.random.randn(out_channels, in_channels, 5, 5)
    npbias = np.random.randn(out_channels)

    # torch tensors for testing custom conv layer
    myconv_input = torch.from_numpy(npinp).cuda(); myconv_input.requires_grad=True
    myconv_weights = torch.from_numpy(npweights).cuda(); myconv_weights.requires_grad=True
    myconv_bias = torch.from_numpy(npbias).cuda(); myconv_bias.requires_grad=True

    # apply own written convolution
    myconv_out = Conv2D(myconv_input, myconv_weights, myconv_bias)
    myconv_out.sum().log().backward()

    #-----------------------------------------------------------------
    
    # use pytorch inbuild function
    fconv_input = torch.from_numpy(npinp).cuda(); fconv_input.requires_grad=True
    fconv_weights = torch.from_numpy(npweights).cuda(); fconv_weights.requires_grad=True
    fconv_bias = torch.from_numpy(npbias).cuda(); fconv_bias.requires_grad=True

    fconv_out = F.conv2d(fconv_input, fconv_weights, fconv_bias, dilation=1, padding=2, stride=1)
    fconv_out.sum().log().backward()

    # assert for equality
    assert torch.allclose(fconv_out, myconv_out, atol=1e-5)
    assert torch.allclose(fconv_input.grad, myconv_input.grad, atol=1e-5)
    assert torch.allclose(fconv_weights.grad, myconv_weights.grad, atol=1e-5)
    assert torch.allclose(fconv_bias.grad, myconv_bias.grad, atol=1e-5)
    print("all equal!")