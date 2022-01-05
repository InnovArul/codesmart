from collections import defaultdict
class Solution:
    def validArrangement(self, pairs: List[List[int]]) -> List[List[int]]:
        nodehash = defaultdict(lambda: [])
        inhash = defaultdict(lambda: 0)        
        outhash = defaultdict(lambda: 0)

        for i, j in pairs:
            nodehash[i].append(j)
            inhash[j] += 1
            outhash[i] += 1
        
        allnodes = set(list(inhash.keys()) + list(outhash.keys()))
        cornernodes = []
        for n in allnodes:
            if inhash[n] != outhash[n] and outhash[n] > inhash[n]:
                cornernodes.append(n)
        
        # selection of start node
        if len(cornernodes): start = cornernodes[0]
        else: start = list(allnodes)[0]
            
        path = []        
        
        nextnode = start
        while len(nodehash):
            curr = nodehash[nextnode][0]
            path.append([nextnode, curr])
            
            nodehash[nextnode] = nodehash[nextnode][1:]
            if len(nodehash[nextnode]) == 0:
                del nodehash[nextnode]
            
            nextnode = curr
        
        return path
            
        
        
        