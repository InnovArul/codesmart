import os, sys, numpy as np

def perform_FFT_vectorized(x):
    N = x.shape[0]

    if np.log2(N) % 1 > 0:
        raise ValueError("size of x must be a power of 2")

    # N_min here is equivalent to the stopping condition above,
    # and should be a power of 2
    N_min = min(N, 32)
    
    # Perform an O[N^2] DFT on all length-N_min sub-problems at once
    n = np.arange(N_min)
    k = n[:, None]
    M = np.exp(-2j * np.pi * n * k / N_min)
    # print(M.shape)
    X = np.dot(M, x.reshape((N_min, -1)))
    # print(X.shape)

    # build-up each level of the recursive calculation all at once
    while X.shape[0] < N:
        # print(X.shape[0])
        X_even = X[:, :X.shape[1] // 2]
        X_odd = X[:, X.shape[1] // 2:]
        # print(X_even.shape)
        # print(X_odd.shape)
        factor = np.exp(-1j * np.pi * np.arange(X.shape[0])
                        / X.shape[0])[:, None]
        X = np.vstack([X_even + factor * X_odd,
                       X_even - factor * X_odd])
        # print(X.shape)

    return X.ravel()

if __name__ == '__main__':
    data = np.random.random(1024)
    fft1d = perform_FFT_vectorized(data)
    print(np.allclose(fft1d, np.fft.fft(data)))
