# https://discuss.pytorch.org/t/freezing-a-network-problem/105938
import torch, torch.nn as nn
import torch.nn.functional as F
import os, sys
import copy
import torch.optim as optim

class ConvReLU(nn.Module):
    def __init__(self, indim, outdim):
        super().__init__()
        self.conv = nn.Conv2d(indim, outdim, kernel_size=1)

    def forward(self, x):
        return F.relu(self.conv(x))

class CNN(nn.Module):
    def __init__(self):
        super().__init__()
        self.conv1 = ConvReLU(3,6)
        self.conv2 = ConvReLU(6,12)
        self.conv3 = ConvReLU(12,18)
        self.conv4 = ConvReLU(18,18)
        self.conv5 = ConvReLU(18,18)
        self.conv6 = ConvReLU(18,18)
        self.fc1 = nn.Linear(25*18, 100)
        self.fc2 = nn.Linear(100, 10)

    def forward(self, x):
        x = self.conv1(x)
        x = self.conv2(x)
        x = self.conv3(x)
        x = self.conv4(x)
        x = self.conv5(x)
        x = self.conv6(x)
        x = F.relu(self.fc1(x.view(x.shape[0], -1)))
        x = self.fc2(x)
        return x


def freeze_params(model):
    for name, param in model2.named_parameters():
        if param.requires_grad and 'conv1' in name:
            param.requires_grad = False
        if param.requires_grad and 'conv2' in name:
            param.requires_grad = False
        if param.requires_grad and 'conv3' in name:
            param.requires_grad = False
        if param.requires_grad and 'fc1' in name:
            param.requires_grad = False
        if param.requires_grad and 'fc2' in name:
            param.requires_grad = False

        print(name, param.requires_grad)

def copy_weights(src, dst):
    dst.conv1=copy.deepcopy(src.conv1)
    dst.conv2=copy.deepcopy(src.conv2)
    dst.conv3=copy.deepcopy(src.conv3)

def my_loss(x,y):
    loss =torch.norm(x-y,2)
    return loss

if __name__ == "__main__":
    data = torch.randn(2,3,5,5).cuda()
    y = torch.randn(2,10).cuda()

    model1 = CNN().cuda()
    model2 = CNN().cuda()

    copy_weights(model1, model2)
    assert model1.conv1.conv.weight.data_ptr() != model2.conv1.conv.weight.data_ptr()
    assert model1.conv2.conv.weight.data_ptr() != model2.conv2.conv.weight.data_ptr()
    assert model1.conv3.conv.weight.data_ptr() != model2.conv3.conv.weight.data_ptr()

    freeze_params(model2)

    opt = optim.SGD(filter(lambda p: p.requires_grad, model2.parameters()), lr=0.01)

    out = model2(data)
    opt.zero_grad()
    # loss = out.sum()
    loss = my_loss(out,y)
    loss.backward()
    opt.step()
