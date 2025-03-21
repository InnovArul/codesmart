# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
#
# Leetcode provides its own TreeNode definition internally
class Solution:
    def insertIntoBST(self, root, val):
        if not root: return TreeNode(val=val)
        if root.val >= val:
            root.left = self.insertIntoBST(root.left, val)
        else:
            root.right = self.insertIntoBST(root.right, val)
        
        return root
            