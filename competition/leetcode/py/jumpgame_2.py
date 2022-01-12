

class Solution:
    def jump(self, nums):
        n = len(nums)
        if n <= 1: return 0
        
        limit = nums[0]
        currmaxlimit = nums[0]
        jumps = 1
        for i, num in enumerate(nums[1:], 1):
            if i == limit:
                if i == n-1: break
                jumps += 1
                currmaxlimit = max(currmaxlimit, i+num)
                limit = currmaxlimit
            else:
                currmaxlimit = max(currmaxlimit, i+num)
                
        return jumps

if __name__ == "__main__":
    nums = [2,1]
    print(Solution().jump(nums))

    nums = [2,3,1,1,4]
    print(Solution().jump(nums))

    nums = [2,3,0,1,4]
    print(Solution().jump(nums))
