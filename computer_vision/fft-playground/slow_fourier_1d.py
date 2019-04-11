import os, sys, numpy as np
import timeit

def perform_slow_fourier1d(data):
    N = data.shape[0] # data length
    n = np.arange(N) # data indices
    k = n.reshape(N, 1) # frequency indices

    M = np.exp(-2j * np.pi * k * n / N)
    return np.dot(M, data), M

if __name__ == '__main__':
    data = np.random.random(5)

    fft1d, M = perform_slow_fourier1d(data)
    print(np.allclose(fft1d, np.fft.fft(data)))
    print(M)
    print(np.imag(M))


    x = data
    print(timeit.timeit('perform_slow_fourier1d(x)', 'from __main__ import perform_slow_fourier1d, x, np'))
    print(timeit.timeit('np.fft.fft(x)', 'from __main__ import np, x'))