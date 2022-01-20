class Solution:
    def rotateRight(self, head, k):
        if not head and not head.next: return head
        len = 1

        temp = head
        while temp.next:
            temp = temp.next
            len += 1

        temp.next = head
        # temp points to last node
        k = (len - k % len) % len

        while k != 0:
            temp = temp.next

        head = temp.next
        temp.next = None
        return head
