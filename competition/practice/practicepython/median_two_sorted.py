import sys

class Solution:
    def findMedianSortedArrays(self, nums1, nums2) -> float:
        # nums1 shall be the lesser length one always
        if len(nums1) > len(nums2): return self.findMedianSortedArrays(nums2, nums1)

        low = 0
        high = len(nums1)

        while low <= high:
            partition1 = (low + high) // 2
            partition_full = (len(nums1) + len(nums2) + 1) // 2 - partition1
            # print(low, high, partition1, partition_full)

            # determine min and max of partitions in nums1
            maxleft1 = float('-inf') if partition1 == 0 else nums1[partition1 - 1]
            minright1 = float('inf') if partition1 == len(nums1) else nums1[partition1]

            # determine min and max of partitions in full list
            maxleftfull = float('-inf') if partition_full == 0 else nums2[partition_full - 1]
            minrightfull = float('inf') if partition_full == len(nums2) else nums2[partition_full]

            # check if condition is satisfied
            if (maxleft1 <= minrightfull) and (maxleftfull <= minright1):
                # check odd or even total length
                if (len(nums1) + len(nums2)) % 2 == 0:
                    median = (max(maxleft1, maxleftfull) + min(minright1, minrightfull)) * 0.5
                else:
                    median = max(maxleft1, maxleftfull)

                return median

            elif (maxleft1 > minrightfull):
                # we are far too right 
                high = partition1 - 1

            else:
                low = partition1 + 1



if __name__ == "__main__":
    s = Solution()
    nums1 = [1, 1, 1, 1]
    nums2 = [2, 4, 7, 8]
    print(s.findMedianSortedArrays(nums1, nums2))        