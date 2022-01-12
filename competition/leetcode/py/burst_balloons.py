# https://leetcode.com/problems/burst-balloons/
from functools import lru_cache
class Solution:
    def maxCoins(self, nums):
        nums = [1] + nums + [1] # append one on both sides

        @lru_cache(maxsize=None)
        def findmax(i, j):
            if i<0 or j >= len(nums): return 0
            currmax = 0
            for k in range(i+1, j):
                currmax = max(currmax, nums[i] * nums[k] * nums[j] + findmax(i, k) + findmax(k, j))
            
            return currmax
        
        return findmax(0, len(nums) - 1)

        
if __name__ == '__main__':
    l = [1,5]
    print(Solution().maxCoins(l))