
import java.io.PrintWriter;
import java.util.Scanner;

/*************************************************************************
 * Name:  Arulkumar
 * Email: arul.subramaniam@hotmail.com
 *
 * Compilation:  javac LongestPath.java
 * Execution:
 * Dependencies:
 *
 * Description:
 *
 *************************************************************************/
class LongestPath {

    static PrintWriter out = new PrintWriter(System.out);
    static Scanner Reader = new Scanner(System.in);

    public static void main(String[] args) {
        int numTests = Reader.nextInt();
        for (int index = 0; index < numTests; index++) {
            int R = Reader.nextInt();
            int C = Reader.nextInt();

            int[][] matrix = new int[R][C];

            for (int i = 0; i < R; i++) {
                for (int j = 0; j < C; j++) {
                    matrix[i][j] = Reader.nextInt();
                }
            }

            int longestPath = getLongestPath(matrix, 0, 0, 1, R, C);
            out.println(longestPath);
            out.flush();
        }

        out.close();
    }

    private static int getLongestPath(int[][] matrix, int rowIndex, int colIndex, int length, int maxRow, int maxCol) {
        if (rowIndex >= maxRow) {
            return length;
        }
        if (colIndex >= maxCol) {
            return length;
        }

        int currentCellVal = matrix[rowIndex][colIndex];
        int length1 = length, length2 = length, length3 = length, length4 = length, length5 = length, length6 = length, length7 = length, length8 = length;

        // -->
        if ((colIndex + 1 < maxCol) && matrix[rowIndex][colIndex + 1] == currentCellVal + 1) {
            length1 = getLongestPath(matrix, rowIndex, colIndex + 1, length + 1, maxRow, maxCol);
        }

        // <--
        if ((colIndex - 1 >= 0) && matrix[rowIndex][colIndex - 1] == currentCellVal + 1) {
            length2 = getLongestPath(matrix, rowIndex, colIndex - 1, length + 1, maxRow, maxCol);
        }

        // |
        // v
        if ((rowIndex + 1 < maxRow) && matrix[rowIndex + 1][colIndex] == currentCellVal + 1) {
            length3 = getLongestPath(matrix, rowIndex + 1, colIndex, length + 1, maxRow, maxCol);
        }

        // n
        // |
        if ((rowIndex - 1 >= 0) && matrix[rowIndex - 1][colIndex] == currentCellVal + 1) {
            length4 = getLongestPath(matrix, rowIndex - 1, colIndex, length + 1, maxRow, maxCol);
        }

        //diagonal
        if ((colIndex + 1 < maxCol) && (rowIndex + 1 < maxRow) && matrix[rowIndex + 1][colIndex + 1] == currentCellVal + 1) {
            length5 = getLongestPath(matrix, rowIndex + 1, colIndex + 1, length + 1, maxRow, maxCol);
        }

        //diagonal
        if ((colIndex - 1 >= 0) && (rowIndex - 1 >= 0) && matrix[rowIndex - 1][colIndex - 1] == currentCellVal + 1) {
            length6 = getLongestPath(matrix, rowIndex - 1, colIndex - 1, length + 1, maxRow, maxCol);
        }

        //diagonal
        if ((rowIndex - 1 >= 0) && (colIndex + 1 < maxCol) && matrix[rowIndex - 1][colIndex + 1] == currentCellVal + 1) {
            length7 = getLongestPath(matrix, rowIndex - 1, colIndex + 1, length + 1, maxRow, maxCol);
        }

        //diagonal
        if ((rowIndex + 1 < maxRow) && (colIndex - 1 >= 0) && matrix[rowIndex + 1][colIndex - 1] == currentCellVal + 1) {
            length8 = getLongestPath(matrix, rowIndex + 1, colIndex - 1, length + 1, maxRow, maxCol);
        }

        return Math.max(length1, Math.max(length2, Math.max(length3, Math.max(length4, Math.max(length5, Math.max(length6, Math.max(length7, length8)))))));
    }

}
