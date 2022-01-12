# https://leetcode.com/problems/palindrome-partitioning/
class Solution:
    def minCut(self, s):
        dp_pals = {}
        n = len(s)
        # dp_pals[n] = []

        def mincut(i):
            nonlocal dp_pals
            # print(i)
            if i in dp_pals: return dp_pals[i]

            currstr = s[i:]
            if len(currstr) == 0: 
                dp_pals[i] = 0
                return dp_pals[i]

            if len(currstr) == 1: 
                dp_pals[i] = 0
                return dp_pals[i]

            minct = len(currstr) - 1
            for k in range(len(currstr)):
                tocheck = currstr[0:k+1]
                # print(i, k, tocheck)
                if tocheck == tocheck[::-1]: # if the extended string is a palindrome
                    nextcut = mincut(i+k+1)
                    currcut = nextcut
                    if tocheck != currstr: currcut += 1
                    minct = min(minct, currcut)                    

            dp_pals[i] = minct
            return dp_pals[i]

        mincut(0)
        return dp_pals[0]


if __name__ == '__main__':
    s = "geeeks"
    print(Solution().minCut(s))

    # s = "a"
    # print(Solution().partition(s))    

        