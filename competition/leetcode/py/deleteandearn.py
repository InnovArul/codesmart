from sys import maxsize
import numpy as np
from collections import defaultdict
from functools import lru_cache

class Solution:
    def deleteAndEarn(self, nums):
        allnums = defaultdict(int)
        for n in nums:
            allnums[n] += 1

        @lru_cache(maxsize=None)
        def maxearnings(n):
            nonlocal allnums
            if n not in allnums: return 0
            currearning = n*allnums[n]
            #if next number is existing
            if n+1 in allnums:
                if n+2 in allnums:
                    currearning += max(maxearnings(n+2), maxearnings(n+3))
                else: 
                    currearning += maxearnings(n+2)

            return currearning


        nums = list(allnums.keys())
        allmax = 0
        for i, n in enumerate(nums):
            if n-1 not in allnums:
                allmax += max(maxearnings(n), maxearnings(n+1)) 

        return allmax

if __name__ == "__main__":
    nums = [3,1]
    print(Solution().deleteAndEarn(nums))

    nums = [2,2,3,3,3,4]
    print(Solution().deleteAndEarn(nums))