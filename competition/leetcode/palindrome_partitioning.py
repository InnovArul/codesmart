# https://leetcode.com/problems/palindrome-partitioning/
class Solution:
    def partition(self, s):
        dp_pals = {}
        n = len(s)
        # dp_pals[n] = []

        def partition(i):
            nonlocal dp_pals
            # print(i)
            if i in dp_pals: return dp_pals[i]

            currstr = s[i:]
            if len(currstr) == 0: 
                dp_pals[i] = [[]]
                return dp_pals[i]

            if len(currstr) == 1: 
                dp_pals[i] = [[currstr]]
                return dp_pals[i]

            currpals = []
            for k in range(len(currstr)):
                tocheck = currstr[0:k+1]
                # print(i, k, tocheck)
                if tocheck == tocheck[::-1]: # if the extended string is a palindrome
                    nextpals = partition(i+k+1)
                    for pal in nextpals:
                        currpals.append([tocheck] + pal)

            dp_pals[i] = currpals
            return dp_pals[i]

        partition(0)
        return dp_pals[0]


if __name__ == '__main__':
    s = "bb"
    print(Solution().partition(s))

    # s = "a"
    # print(Solution().partition(s))    

        