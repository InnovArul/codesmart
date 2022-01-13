#https://leetcode.com/problems/maximum-length-of-subarray-with-positive-product/
import numpy as np
class Solution:
    def getMaxLen(self, nums):
        n = len(nums)
        ncount = pcount = lastpcount = firstpcount = 0
        ans = 0
        nums.append(0)

        for n in nums:
            if n == 0:
                if ncount % 2 == 0:
                    ans = max(ans, pcount + ncount)
                else:
                    ans = max(ans, pcount - min(lastpcount, firstpcount) + ncount - 1)

                ncount = pcount = lastpcount = firstpcount = 0
            elif n < 0:
                 ncount += 1
                 lastpcount = 0
            else:
                if ncount == 0: firstpcount += 1
                else: lastpcount += 1
                pcount += 1

        return ans


if __name__ == '__main__':
    nums = [6,2,10,1,-2,8]
    print(Solution().getMaxLen(nums))

    nums = [0,1,-2,-3,-4]
    print(Solution().getMaxLen(nums))
    
    nums = [-1,-2,-3,0,1]
    print(Solution().getMaxLen(nums))
