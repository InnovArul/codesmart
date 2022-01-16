#https://leetcode.com/contest/weekly-contest-276/problems/maximum-running-time-of-n-computers/

class Solution:
    def maxRunTime(self, n, batteries):
        batlen = len(batteries)
        batsum = sum(batteries)
        low = 0 
        high = batsum // n
        ans = 0

        def check_run(amount):
            nonlocal n, batlen
            checksum = amount * n
            total = 0
            for b in batteries:
                total += min(b, amount)

            return total >= checksum

        while (low <= high):
            mid = (low + high) // 2
            if check_run(mid):
                low = mid + 1
                ans = mid
            else:
                high = mid - 1

        return ans
