# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
import sys
 
 # 0-indexed min heap
class MinHeap:
 
    def __init__(self):
        self.Heap = []
        self.FRONT = 0
 
    # Function to return the position of
    # parent for the node currently
    # at pos
    @property
    def size(self):
        return len(self.Heap)

    def parent(self, pos):
        if pos == 0: return 0
        return (pos-1)//2

    def getVal(self, pos):
        return self.Heap[pos].val

    # Function to return the position of
    # the left child for the node currently
    # at pos
    def leftChildPos(self, pos):
        return 2 * pos + 1
 
    def leftChildVal(self, parent):
        leftpos = self.leftChildPos(parent)
        if self.isValidPos(leftpos): return self.getVal(leftpos)
        else: return -1

    # Function to return the position of
    # the right child for the node currently
    # at pos
    def rightChildPos(self, pos):
        return (2 * pos) + 2

    def rightChildVal(self, parent):
        rightpos = self.rightChildPos(parent)
        if self.isValidPos(rightpos): return self.getVal(rightpos)
        else: return -1

    def isValidPos(self, pos):
        if pos < 0 or pos >= self.size:
            return False
        return True

    # Function that returns true if the passed
    # node is a leaf node
    def isLeaf(self, pos):
        if pos >= (self.size//2) and pos < self.size:
            return True
        return False
 
    # Function to swap two nodes of the heap
    def swap(self, fpos, spos):
        self.Heap[fpos], self.Heap[spos] = self.Heap[spos], self.Heap[fpos]
 
    def getNextMinHeapifyPosition(self, pos):
        leftChildPos = self.leftChildPos(pos)
        rightChildPos = self.rightChildPos(pos)
        currvalue = self.getVal(pos)

        if self.isValidPos(rightChildPos): # both children are valid
            leftChildVal = self.getVal(leftChildPos)
            rightChildVal = self.getVal(rightChildPos)

            # return the least value's position
            if currvalue > leftChildVal or currvalue > rightChildVal:
                return leftChildPos if leftChildVal <= rightChildVal else rightChildPos
            else: return -1

        elif self.isValidPos(leftChildPos):
            # only left child
            leftChildVal = self.getVal(leftChildPos)
            if leftChildVal < currvalue:
                return leftChildPos
            

        return -1

    def isEmpty(self):
        return len(self.Heap) == 0

    # Function to heapify the node at pos
    def minHeapify(self, pos):
        # If the node is a non-leaf node and greater
        # than any of its child
        if not self.isLeaf(pos):
            nextpos = self.getNextMinHeapifyPosition(pos)
            if (nextpos != -1): 
                # Swap with the nextpos and heapify
                self.swap(pos, nextpos)
                self.minHeapify(nextpos)

 
    # Function to insert a node into the heap
    def insert(self, element):
        if element is None: return
        self.Heap.append(element)
        current = self.size - 1
 
        while self.getVal(current) < self.getVal(self.parent(current)):
            self.swap(current, self.parent(current))
            current = self.parent(current)
 
    # Function to print the contents of the heap
    def Print(self):
        for i in range(0, self.size//2):
            print(f" PARENT : {str(self.Heap[i])} LEFT CHILD : "+
                    f"{self.leftChildVal(i)} RIGHT CHILD : {self.rightChildVal(i)}")
 
    # Function to build the min heap using
    # the minHeapify function
    def minHeap(self):
        for pos in range(self.size//2, 0, -1):
            self.minHeapify(pos)
 
    # Function to remove and return the minimum
    # element from the heap
    def remove(self):
        if self.size == 0: return None

        popped = self.Heap[self.FRONT]
        temp = self.Heap[-1]
        self.Heap.pop()

        # min heapify if the heap is not empty
        if self.size != 0:
            self.Heap[self.FRONT] = temp
            self.minHeapify(self.FRONT)

        # remove the first element
        if popped.next: self.insert(popped.next)

        return popped
 
class Solution:
    def mergeKLists(self, lists):
        mh = MinHeap()
        for l in lists:
            mh.insert(l)
        
        mergedlist = None
        headlist = None
        while not mh.isEmpty():
            if mergedlist is None:
                mergedlist = mh.remove()
                headlist = mergedlist
            else:
                mergedlist.next = mh.remove()
                mergedlist = mergedlist.next
            
            mergedlist.next = None
        
        return headlist
