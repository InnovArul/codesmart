#https://leetcode.com/problems/solving-questions-with-brainpower/

# bottom up approach
class Solution:
    def mostPoints(self, questions):
        n = len(questions)

        dp = [0] * n
        dp[n-1] = questions[n-1][0]
        
        for i in range(n-2, -1, -1):
            pick = questions[i][0]
            if i + questions[i][1] + 1 < n: pick += dp[i + questions[i][1] + 1]
            notpick = dp[i+1]
            dp[i] = max(pick, notpick)
        
        return dp[0]


# top down approach
class Solution:
    def mostPoints(self, questions):
        n = len(questions)
        
        @cache
        def aux(i):
            nonlocal n
            if i >= n: return 0
            maxpoint = questions[i][0] + aux(i+questions[i][1]+1)
            maxpoint = max(maxpoint, aux(i+1))
            return maxpoint
        
        return aux(0)