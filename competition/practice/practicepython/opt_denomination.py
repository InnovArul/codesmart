import numpy as np
import math

# https://www.codechef.com/JULY21C/problems/MINNOTES

def gcd(a: int, b: int): return gcd(b, a % b) if b else a

if __name__ == "__main__":
    T = int(input())
    for _ in range(T):
        N = int(input())
        numarray = np.array(list(map(int, input().split())))

        # find the min number
        minnum = np.min(numarray)
        maxindex = np.argmax(numarray)
        temparray = numarray.copy()
        temparray[maxindex] = 0 # replace max element

        all_gcd = 0
        for denom in reversed(range(minnum)):
            curr_denom = denom + 1  
            if np.all(temparray % curr_denom == 0): 
                all_gcd = curr_denom
                break

        numarray[maxindex] = all_gcd
        print(int(sum(numarray / all_gcd)))