class Solution:
    def maxProduct(self, nums):
        maxprod_so_far = nums[0]
        maxprod_end_here = nums[0]
        minprod_end_here = nums[0]
        
        for n in nums[1:]:
            temp = max(n, n*maxprod_end_here, n*minprod_end_here)
            minprod_end_here = min(n, n*maxprod_end_here, n*minprod_end_here)
            maxprod_end_here = temp
            maxprod_so_far = max(maxprod_so_far, maxprod_end_here)
            
        return maxprod_so_far


if __name__ == "__main__":
    nums = [1,2,0,3,4]
    print(Solution().maxProduct(nums))