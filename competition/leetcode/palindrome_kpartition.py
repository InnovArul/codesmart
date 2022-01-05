# https://leetcode.com/problems/palindrome-partitioning-iii/
import numpy as np
class Solution:
    def palindromePartition(self, s, k):
        dp_pals = {}

        def partition(st, k):
            nonlocal dp_pals
            if (st, k) in dp_pals: return dp_pals[(st, k)]
            if len(st) == k: return 0 # if number of chars is equal to k, no partitioning needed
            n = len(st)
            if k == 1: 
                dp_pals[(st, k)] = sum([st[i] != st[-i-1] for i in range(n//2)])
                # print(f"k=1 check {st} {dp_pals[(st, k)]}")
                return dp_pals[(st, k)]
            
            # now k >= 2
            res = float("Inf")
            for ik in range(1, n-k+2):
                res = min(res, partition(st[:ik], 1) + partition(st[ik:], k-1))

            dp_pals[(st, k)] = res
            # print(f"check {st} {dp_pals[(st, k)]}")
            return res
        
        return partition(s, k)


if __name__ == '__main__':
    s = "abc"
    print(Solution().palindromePartition(s, 2))

    # s = "a"
    # print(Solution().partition(s))    

        