#https://leetcode.com/problems/minimum-number-of-arrows-to-burst-balloons/

class Solution:
    def findMinArrowShots(self, points):
        points = sorted(points)
        all_intersections = [points[0]]

        def isintersect(p1, p2):
            x11, x12 = p1
            x21, x22 = p2

            if x11 <= x21 <= x12: return True
            if x11 <= x22 <= x12: return True
            return False

        def find_intersect(p1, p2):
            x11, x12 = p1
            x21, x22 = p2
            a1 = max(x11, x21)
            a2 = min(x12, x22)
            return (a1, a2)

        for p in points[1:]:
            candidate = all_intersections[-1]
            if isintersect(candidate, p):
                all_intersections.pop()
                all_intersections.append(find_intersect(candidate, p))
            else: all_intersections.append(p)

        return len(all_intersections)

if __name__ == "__main__":
    points = [[10,16],[2,8],[1,6],[7,12]]
    print(Solution().findMinArrowShots(points))

    points = [[1,2],[3,4],[5,6],[7,8]]
    print(Solution().findMinArrowShots(points))

    points = [[1,2],[2,3],[3,4],[4,5]]
    print(Solution().findMinArrowShots(points))