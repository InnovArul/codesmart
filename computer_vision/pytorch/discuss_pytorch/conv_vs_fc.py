# https://discuss.pytorch.org/t/discrepancy-between-theory-and-practice/106075

import torch
from torch import nn
torch.set_default_dtype(torch.double)

if __name__ == "__main__":
    for i in range(100):
        b=2
        outc = 10
        inc = 10
        res = 32
    
        input_tensor = torch.randn((b, inc, res, res))
        cnn_layer = nn.Conv2d(in_channels=inc, out_channels=outc, kernel_size=res,)
        out_cnn_layer = cnn_layer(input_tensor).view(b,-1)

        # fc
        fc_layer = nn.Linear(in_features=inc * res * res, out_features=outc)
        fc_layer.weight.data = cnn_layer.weight.data.reshape(outc, -1)
        fc_layer.bias.data = cnn_layer.bias.data
        out_fc_layer = fc_layer(input_tensor.view(b, -1))

        # manual
        manual_fc = torch.matmul(input_tensor.view(b, -1), cnn_layer.weight.data.reshape(outc, -1).t()) + cnn_layer.bias.data.view(1, -1)
        # print("cnn vs. fc, isequal: ", torch.allclose(out_cnn_layer, out_fc_layer), ", abs error: ", torch.norm(out_cnn_layer-out_fc_layer).item())
        assert torch.allclose(out_cnn_layer, out_fc_layer)
        assert torch.allclose(out_cnn_layer, manual_fc)
        assert torch.allclose(out_fc_layer, manual_fc)
        # print(out_cnn_layer[:, 0], out_fc_layer[:,0])
        # print("cnn vs. manual, isequal: ", torch.allclose(out_cnn_layer, manual_fc), ", abs error: ", torch.norm(out_cnn_layer-manual_fc).item())
        # print(out_cnn_layer[:, 0], manual_fc[:,0])
        # print("fc vs. manual, isequal: ", torch.allclose(out_fc_layer, manual_fc), ", abs error: ", torch.norm(out_fc_layer-manual_fc).item())
        # print(out_fc_layer[:, 0], manual_fc[:,0])
        # input()
        print(i, "ok!")