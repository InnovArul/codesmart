from binarytree import tree, Node
from collections import deque
import random

def serialize(mytree):
    # do preorder traversal
    if mytree is None:
        return "X"
    
    myval = str(mytree.val)
    # serialize left and right subtrees
    left_serial = serialize(mytree.left)
    right_serial = serialize(mytree.right)

    # encode the node
    return myval + "," + left_serial + "," + right_serial

def deserialize(deq):
    # pop the current node
    curr_node = deq[0]
    deq.popleft()

    if curr_node == 'X': return None
    
    # if its not X, create node with left and right children
    left_node = deserialize(deq)
    right_node = deserialize(deq)

    curr_node = Node(value=int(curr_node), left=left_node, right=right_node)
    return curr_node


if __name__ == '__main__':
    # generate a random tree
    random_height = random.randint(3, 9)
    print(f"height {random_height}")
    mytree = tree(height=random_height, is_perfect=False)
    print(mytree)

    serial_str = serialize(mytree)
    print(serial_str)

    deq = deque(serial_str.split(','))
    deserial_tree = deserialize(deq)
    print(deserial_tree)

    print(f"is both trees equal? {mytree.values == deserial_tree.values}")