import os, sys, numpy as np
import timeit
from slow_fourier_1d import perform_slow_fourier1d

def perform_fast_fourier1d(x):
    N = x.shape[0]

    if N%2 > 0:
        raise ValueError("size of x must be a power of 2")
    elif N <= 32: # bottleneck at length 32
        return perform_slow_fourier1d(x)[0]
    else:
        X_even = perform_fast_fourier1d(x[::2])
        X_odd = perform_fast_fourier1d(x[1::2])
        factor = np.exp(-2j * np.pi * np.arange(N) / N)
        return np.concatenate([X_even + factor[:N//2] * X_odd,
                                X_even + factor[N//2:] * X_odd])

if __name__ == '__main__':
    data = np.random.random(64)
    fft1d = perform_fast_fourier1d(data)
    print(np.allclose(fft1d, np.fft.fft(data)))

    x = data
    print(timeit.timeit('perform_fast_fourier1d(x)', 'from __main__ import perform_fast_fourier1d, perform_slow_fourier1d, x, np'))
    print(timeit.timeit('np.fft.fft(x)', 'from __main__ import np, x'))