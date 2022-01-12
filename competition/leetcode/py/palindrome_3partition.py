# https://leetcode.com/problems/palindrome-partitioning-iv/
class Solution:
    def checkPartitioning(self, s):
        dp_pals = {}
        n = len(s)
        # dp_pals[n] = []

        def partition(i):
            nonlocal dp_pals
            # print(i)
            if i in dp_pals: return dp_pals[i]

            currstr = s[i:]
            if len(currstr) == 0: 
                dp_pals[i] = [0,]
                return dp_pals[i]

            if len(currstr) == 1: 
                dp_pals[i] = [0,]
                return dp_pals[i]

            cuts = []
            for k in range(len(currstr)):
                tocheck = currstr[0:k+1]
                # print(i, k, tocheck)
                if tocheck == tocheck[::-1]: # if the extended string is a palindrome
                    nextcuts = partition(i+k+1)
                    for ct in nextcuts:
                        currcut = ct
                        if tocheck != currstr: currcut += 1
                        if currcut <= 2: cuts.append(currcut)            

            dp_pals[i] = set(cuts)
            return dp_pals[i]

        partition(0)
        print(dp_pals)
        return 2 in dp_pals[0]


if __name__ == '__main__':
    s = "bcbddxy"
    print(Solution().checkPartitioning(s))

    # s = "a"
    # print(Solution().partition(s))    

        