import sys, os
# https://www.youtube.com/watch?v=DPeHFXJK95w

if not os.environ.get('ONLINE_JUDGE'):
    sys.stdin = open("in.txt", 'r')
    sys.stdout = open("out.txt", 'w')


def reverse(array, start, end):
    midlength = (end - start) // 2
    for i in range(midlength + 1):
        temp = array[start + i]
        array[start + i] = array[end - i]
        array[end - i] = temp


def reversort(array):
    cost = 0
    for i in range(len(array) - 1):
        # find the smallest index from i to length
        minindex = i
        for j in range(i, len(array)):
            minindex = j if array[j] < array[minindex] else minindex
        
        # reverse subarray from i to minindex
        reverse(array, i, minindex)

        cost += (minindex - i) + 1
    
    return cost

if __name__ == '__main__':
    T = int(input())
    for i in range(T):
        nums = list(map(int, input().split()))
        cost = reversort(nums)
        print(nums, f", cost = {cost}")