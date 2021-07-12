import numpy as np
import math

if __name__ == "__main__":
    T = int(input())
    for i in range(T):
        N, K = map(int, input().split())
        numarray = np.array(map(int, input().split()))

        opcount = 0
        while not np.all(numarray == 0):
            opcount += math.ceil(sum(numarray & 1) * 1. / K)
            numarray >>= 1

        print(opcount)