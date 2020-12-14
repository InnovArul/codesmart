import torch
torch.set_default_dtype(torch.float)

if __name__ == '__main__':

    # 1
    a = torch.rand(4, 5, 6, 7)
    b = torch.rand(4, 6, 7, 9, 6, 7)
    print(torch.allclose(torch.einsum('bdnxy->bdxy', torch.einsum('bdhw,bhwnxy->bdnxy', a, b)), torch.einsum('bdhw,bhwnxy->bdxy', a, b)))

    # 2
    a = torch.randint(low=1, high=10, size=(4, 5, 6, 7))
    b = torch.randint(high=4, size=(4, 6, 7, 9, 6, 7))
    print(torch.allclose(torch.einsum('bdnxy->bdxy', torch.einsum('bdhw,bhwnxy->bdnxy', a, b)), torch.einsum('bdhw,bhwnxy->bdxy', a, b)))

    # 3
    a = torch.rand(4, 5, 6, 7)
    b = torch.rand(4, 6, 7, 9, 6, 7)
    c = torch.bmm(a.reshape(4, 5, 6*7), b.reshape(4, 6*7, -1)).reshape(4, 5, 9, 6, 7).sum(dim=2)
    print(torch.allclose(torch.einsum('bdnxy->bdxy', torch.einsum('bdhw,bhwnxy->bdnxy', a, b)), c))
    print(torch.allclose(torch.einsum('bdnxy->bdxy', torch.einsum('bdhw,bhwnxy->bdnxy', a, b)), torch.einsum('bdhw,bhwnxy->bdxy', a, b)))
    print(torch.allclose(torch.einsum('bdnxy->bdxy', torch.einsum('bdhw,bhwnxy->bdnxy', a, b)), torch.einsum('bdhw,bhwnxy->bdxy', a, b)))