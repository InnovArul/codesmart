# https://leetcode.com/problems/house-robber-ii/
from functools import lru_cache

class Solution:
    def rob(self, nums):
        n = len(nums)
        currnums = nums
        if len(currnums) == 0: return 0
        if len(currnums) == 1: return currnums[0]
        if len(currnums) == 2: return max(currnums[0], currnums[1])
        if len(currnums) == 3: return max(currnums)

        @lru_cache(maxsize=None)
        def aux(i, end):
            nonlocal nums
            currnums = nums[i:end]
            if len(currnums) == 0: return 0
            if len(currnums) == 1: return currnums[0]
            if len(currnums) == 2: return max(currnums[0], currnums[1])

            currval = currnums[0]
            return max(aux(i+2, end), aux(i+3, end)) + currval

        return max(aux(0,n-1), aux(1,n), aux(2,n))


if __name__ == "__main__":
    nums = [1]
    print(Solution().rob(nums))

    nums = [1,2,3]
    print(Solution().rob(nums))

    nums = [1,2,3,1]
    print(Solution().rob(nums))
