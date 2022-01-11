# https://leetcode.com/problems/number-of-provinces/
from collections import defaultdict
class Solution:
    def findCircleNum(self, isConnected):
        r = len(isConnected)
        c = len(isConnected[0])

        # prepare adj matrix
        edges = defaultdict(list)
        for i in range(r):
            for j in range(c):
                if isConnected[i][j]:
                    edges[i].append(j)
                    edges[j].append(i)
            
        visited = [False] * r
        def dfs(i):
            nonlocal edges
            nonlocal visited 
            visited[i] = True

            for j in edges[i]:
                if not visited[j]: dfs(j)

        numcomp = 0
        for n in range(r):
            if not visited[n]:
                numcomp += 1
                dfs(n)

        return numcomp

if __name__ == '__main__':
    isconnected = [[1,1,0],[1,1,0],[0,0,1]]
    print(Solution().findCircleNum(isconnected))

    isconnected = [[1,0,0],[0,1,0],[0,0,1]]
    print(Solution().findCircleNum(isconnected))