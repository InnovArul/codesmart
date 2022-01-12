

class Solution:
    def canJump(self, nums):
        limit = nums[0]
        
        for i, n in enumerate(nums[1:], 1):
            if i <= limit:
                limit = max(limit, i+n)
            else:
                return False

        return True

if __name__ == "__main__":
    nums = [3,2,1,0,4]
    print(Solution().canJump(nums))

    nums = [2,3,1,1,4]
    print(Solution().canJump(nums))
