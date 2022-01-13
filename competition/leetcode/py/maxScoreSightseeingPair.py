
#https://leetcode.com/problems/best-sightseeing-pair/
class Solution:
    def maxScoreSightseeingPair(self, nums):
        cur = nums[0] - 1
        res = 0

        for n in nums[1:]:
            res = max(res, cur+n)
            cur = max(cur-1, n-1)

        return res


if __name__ == "__main__":
     nums = [8,1,5,2,6]
     print(Solution().maxScoreSightseeingPair(nums))

     nums = [5,1]
     print(Solution().maxScoreSightseeingPair(nums))
        