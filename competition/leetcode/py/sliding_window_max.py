import sys
class Solution:
    def maxSlidingWindow(self, nums):
        ans = []
        currmax = -sys.maxsize
        for i in range(k):
            currmax = max(currmax, nums[i])
        
        ans.append(currmax)
        
        for i, n in enumerate(nums[k:], k):
            currmax = max(currsum, prevmax)
            ans.append(currmax)
            prevmax = currmax
        
        return ans


if __name__ == '__main__':
    nums = [1,3,-1,-3,5,3,6,7]
    k = 3
    print(Solution().maxSlidingWindow(nums, k))