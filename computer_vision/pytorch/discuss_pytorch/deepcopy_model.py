import torch, torch.nn as nn, torch.nn.functional as F
import copy 

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

if __name__ == '__main__':

    model1 = CNN().cuda()
    model2 = copy.deepcopy(model1)
    # print(model1.conv1.conv.weight[0], "\n", model2.conv1.conv.weight[0], )
    # print(list(model1.children()))
    print(list(model1.modules()))

    # reset params 
    for name, layer in model2.named_modules():
        print(name)
        if hasattr(layer, 'reset_parameters'):
           print("reset")
           layer.reset_parameters()

    # print("after reset", model1.conv1.conv.weight[0], "\n", model2.conv1.conv.weight[0], )
