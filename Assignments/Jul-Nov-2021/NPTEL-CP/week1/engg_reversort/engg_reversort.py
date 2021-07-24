import sys, os
# https://youtu.be/AbIF_RLHklE

if not os.environ.get('ONLINE_JUDGE'):
    sys.stdin = open("in.txt", 'r')
    sys.stdout = open("out.txt", 'w')

    import os.path as osp
    this_path = osp.split(osp.abspath(__file__))[0]
    parent_path = osp.join(this_path, '..')
    sys.path.insert(0, parent_path)

    from reversort.reversort import reversort, reverse

def engg_reversort(N, cost, minelement):

    if N == 1: # base case
        return [minelement,]
    else:
        # difference between current cost and list(N-1) max cost
        if (cost-1) >= N-2 and (cost-1) <= (N * (N-1) // 2 - 1): 
            # if within list(N-1) min and max cost, then construct N-1 list and prepend minelement
            return [minelement,] + engg_reversort(N-1, cost - 1, minelement + 1)
        else:
            delta = cost - (N * (N-1) // 2 - 1)

            # if delta is positive, then construct N-1 list and rearrange 0th element to reflect delta
            curr_list = [minelement, ] + engg_reversort(N-1, cost - delta, minelement + 1)
            reverse(curr_list, 0, delta-1)
            return curr_list


if __name__ == '__main__':
    T = int(input())
    for i in range(T):
        N, cost = list(map(int, input().split()))
        if cost < N-1 or cost > N * (N+1) // 2 - 1:
            l = []
        else:
            l = engg_reversort(N, cost, 1)

        if not os.environ.get('ONLINE_JUDGE'):
            if len(l) > 0:
                predlist = list(l)
                estcost = reversort(l)
                print(f"len: {N}, cost: {cost}, pred list: {predlist}, estimated: {estcost}")
            else:
                print(f"len: {N}, cost: {cost}, pred list: {l}")