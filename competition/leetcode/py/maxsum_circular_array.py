class Solution:
    def maxSubarraySumCircular(self, nums):
        n = len(nums)

        def get_maxsum_from_fixedend(ns):
            nonlocal n
            maxsofar = ns[0]
            sumtillhere = 0
            maxsum = [0] * n

            for i, num in enumerate(ns,0):
                sumtillhere += num
                maxsofar = max(maxsofar, sumtillhere)
                #maxtillhere = max(maxtillhere, 0)
                maxsum[i] = maxsofar
                
            return maxsum

        def get_kadane_maxsum(ns):
            nonlocal n
            maxsofar = ns[0]
            maxtillhere = 0
            maxs = [0] * n
            maxs[0] = maxsofar

            for i, num in enumerate(ns,0):
                maxtillhere += num
                maxsofar = max(maxsofar, maxtillhere)
                maxtillhere = max(maxtillhere, 0)
                maxs[i] = maxsofar
                
            return maxs

        kadanemax = get_kadane_maxsum(nums)
        leftmax = get_maxsum_from_fixedend(nums)
        rightmax = get_maxsum_from_fixedend(nums[::-1])[::-1]

        ans = max(kadanemax)
        for i in range(n-1):
            ans = max(ans, leftmax[i]+rightmax[i+1])

        return ans

if __name__ == '__main__':
    nums = [1,-2,3,-2]
    print(Solution().maxSubarraySumCircular(nums))

    nums = [5,-3,5]
    print(Solution().maxSubarraySumCircular(nums))

    nums = [-3,-2,-3]
    print(Solution().maxSubarraySumCircular(nums))
    
    nums = [-2,2,-2,9]
    print(Solution().maxSubarraySumCircular(nums))