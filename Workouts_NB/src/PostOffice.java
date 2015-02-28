
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Scanner;

/**
 *
 * @author Arulkumar
 *
 */
class PostOffice {

    /**
     * @param args
     */
    private static int W_xMax, H_yMax, NumOfConstructions;
    private static Scanner scann;
    private static int[][] Memoize = null;
    private static boolean[][] IsMemoized = null;

    private static void MemoizePoint(int i_x, int j_y, int max) {
        Memoize[i_x][j_y] = max;
        IsMemoized[i_x][j_y] = true;
    }

    private static void printSeenPoints(ArrayList<Point> seenPoints) {
        for (Iterator<Point> iter = seenPoints.iterator(); iter.hasNext();) {
            Point point = iter.next();
            System.out.print(point.x + "" + point.y + "->");
        }
        System.out.print("\n");
    }

    private static boolean isThisOnlyChoiceForPrev(int i_x, int j_y, ArrayList<Point> seenPoints) {
        Point pt = seenPoints.get(seenPoints.size()-1);

        // check
        return true;
    }

    /**
     *
     * @author Arulkumar
     *
     *         A compact class to hold a point
     */
    static class Point {

        int x, y;

        /**
         * constructor
         *
         * @param x
         * @param y
         */
        public Point(int x, int y) {
            super();
            this.x = x;
            this.y = y;
        }

        /**
         * to check if two points are equal
         *
         * @param x1
         * @param y1
         * @return true or false
         */
        boolean isEqual(int x1, int y1) {
            if (x == x1 && y == y1) {
                return true;
            }
            return false;
        }

        Point cloneIt() {
            return new Point(x, y);
        }

        @Override
        public boolean equals(Object oInput) {
            if (((Point) oInput).x == x && ((Point) oInput).y == y) {
                return true;
            }
            return false;
        }

        @Override
        public int hashCode() {
            int hash = 5;
            hash = 67 * hash + this.x;
            hash = 67 * hash + this.y;
            return hash;
        }
    }
    static ArrayList<Point> constructionPoints = null;
    static int nMinCost = Integer.MAX_VALUE, nCount = 0;

    /**
     *
     * @param args
     */
    public static void main(String[] args) {
        scann = new Scanner(System.in);
        constructionPoints = new ArrayList<Point>();

        // get the number of tests
        int numberOfTests = scann.nextInt();

        // validation for number of tests
        if (numberOfTests < 1 || numberOfTests > 30) {
            System.out.println("wrong!");
            return;
        }

        // for each test, find the minimum number of paths
        for (int index = 0; index < numberOfTests; index++) {
            // reset the counters & buffers
            nMinCost = Integer.MAX_VALUE;
            nCount = 0;
            constructionPoints.clear();

            // skip the next line
            scann.nextLine();

            // scan the W, H, N
            // max possible W, H 100110001001011010000000. so, int type is
            // enough
            W_xMax = scann.nextInt();
            H_yMax = scann.nextInt();
            NumOfConstructions = scann.nextInt();

            // validate W, H, N
            if (W_xMax < 1 || W_xMax > Math.pow(10, 7) || H_yMax < 1
                    || H_yMax > Math.pow(10, 7)) {
                System.out.println("wrong!");
                return;
            }

            if (NumOfConstructions < 0
                    || NumOfConstructions > Math.max(100,
                    Math.min(W_xMax, Math.min(H_yMax, 1000)))) {
                System.out.println("wrong!");
                return;
            }

            Memoize = new int[W_xMax + 1][H_yMax + 1];
            Memoize[W_xMax][H_yMax] = 1;
            IsMemoized = new boolean[W_xMax + 1][H_yMax + 1];
            IsMemoized[W_xMax][H_yMax] = true;

            // read construction points
            for (int constructPointIndex = 0; constructPointIndex < NumOfConstructions; constructPointIndex++) {
                int x = scann.nextInt();
                int y = scann.nextInt();

                if (!isValidPoint(x, y)) {
                    System.out.println("wrong!");
                    return;
                }

                constructionPoints.add(new Point(x, y));
                IsMemoized[x][y] = true;
            }


            getNumberOfPaths(0, 0, new ArrayList<PostOffice.Point>());

            // print minimum number of paths
            System.out.println(nCount % 1000000037);

        }

    }

    /**
     *
     * @param i_x
     * @param j_y
     * @return
     */
    private static int getNumberOfPaths(int i_x, int j_y,
            ArrayList<Point> seenPoints) {

        boolean isRightValid = isValidPoint(i_x, j_y + 1) && !isConstructionPoint(i_x, j_y + 1);
        boolean isDownValid = isValidPoint(i_x + 1, j_y) && !isConstructionPoint(i_x + 1, j_y);
        boolean isUpValid = isValidPoint(i_x - 1, j_y) && !isConstructionPoint(i_x - 1, j_y);
        boolean isLeftValid = isValidPoint(i_x, j_y - 1) && !isConstructionPoint(i_x, j_y - 1);


        Point currentPoint = new Point(i_x, j_y);

        // if the length is already greater than min cost length, return 0
        // get the size of path
        int pathLength = seenPoints.size();

        // exit criterias
        // if the given point is already seen, return 0
        if (hasSeen(i_x, j_y, seenPoints)) {
            return 0;
        }


        // if the final point is reached
        if (i_x == W_xMax && j_y == H_yMax) {

            // if the current path is minimum, increment the count
            if (nMinCost == pathLength) {
                nCount++;
            } else if (pathLength < nMinCost) {
                // if the current path is the first minimum, init the count to 1
                //System.out.println("min path length = " + pathLength);
                nMinCost = pathLength;
                nCount = 1;
            }
            printSeenPoints(seenPoints);
            return 1;
        }

        if (IsMemoized[i_x][j_y]) {
            return Memoize[i_x][j_y];
        }

        // consider the current as already seen
        seenPoints.add(currentPoint);

        printSeenPoints(seenPoints);

        // get the number of paths after going to right, left, up, down points
        int right = 0, down = 0, left = 0, up = 0;
        if (isRightValid) {
            right = getNumberOfPaths(i_x, j_y + 1, cloneList(seenPoints));
        }

        if (isDownValid) {
            down = getNumberOfPaths(i_x + 1, j_y, cloneList(seenPoints));
        }


        if (isUpValid) {
            left = getNumberOfPaths(i_x - 1, j_y, cloneList(seenPoints));
        }

        if (isLeftValid) {
            up = getNumberOfPaths(i_x, j_y - 1, cloneList(seenPoints));
        }


        int totalPaths = right + left + up + down;

        printSeenPoints(seenPoints);

        if (((!isRightValid || IsMemoized[i_x][j_y + 1]) && (!isDownValid || IsMemoized[i_x + 1][j_y]) || isThisOnlyChoiceForPrev(i_x, j_y, seenPoints)) ) {
            MemoizePoint(i_x, j_y, (isRightValid ? Memoize[i_x][j_y + 1] : 0)
                    + (isDownValid ? Memoize[i_x + 1][j_y] : 0) + (isUpValid ? Memoize[i_x - 1][j_y] : 0) + (isLeftValid ? Memoize[i_x][j_y - 1] : 0));
        }

        return totalPaths;
    }

    /**
     * to clone the given list
     *
     * @param list
     * @return cloned list
     */
    private static ArrayList<Point> cloneList(ArrayList<Point> list) {
        // clone all the items one by one
        ArrayList<Point> clone = new ArrayList<Point>(list.size());
        for (Point item : list) {
            clone.add(item.cloneIt());
        }
        return clone;
    }

    /**
     * to check if the given point x, y is already seen
     *
     * @param i_x
     * @param j_y
     * @param seenPoints
     * @return true or false
     */
    private static boolean hasSeen(int i_x, int j_y, ArrayList<Point> seenPoints) {
        // for each seen points, check if the given point x, y is equal to any
        // of the seen points
        for (Iterator<Point> iterator = seenPoints.iterator(); iterator.hasNext();) {
            Point point = (Point) iterator.next();
            if (point.isEqual(i_x, j_y)) {
                return true;
            }
        }
        return false;
    }

    /**
     * to check if the given point is a construction point
     *
     * @param i_x
     * @param j_y
     * @return true or false
     */
    private static boolean isConstructionPoint(int i_x, int j_y) {
        for (Iterator<Point> iterator = constructionPoints.iterator(); iterator.hasNext();) {
            Point point = (Point) iterator.next();
            if (point.isEqual(i_x, j_y)) {
                return true;
            }
        }
        return false;
    }

    /**
     * to check if the point is valid
     *
     * @param x
     * @param y
     * @return true or false
     */
    private static boolean isValidPoint(int x, int y) {
        if (x >= 0 && x <= W_xMax && y >= 0 && y <= H_yMax) {
            return true;
        }
        return false;
    }
}
