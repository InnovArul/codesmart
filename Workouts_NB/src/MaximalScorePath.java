
import java.io.PrintWriter;
import java.util.Scanner;

/*
 * Maximal Score Path: http://www.codechef.com/problems/RG_01
 */
/*************************************************************************
 * Name:  Arulkumar
 * Email: arul.subramaniam@hotmail.com
 *
 * Compilation:  javac MaximalScorePath.java
 * Execution:
 * Dependencies:
 *
 * Description:
 *
 *************************************************************************/
class MaximalScorePath {

    private static Scanner in = null;
    private static PrintWriter out = null;

    public static void main(String[] args) {
        int V, E;

        in = new Scanner(System.in);
        out = new PrintWriter(System.out);

        V = in.nextInt();

        if (!IsValid(V, 2, 1000)) {
            return;
        }

        E = in.nextInt();

        if (!IsValid(E, V - 1, V * (V - 1) / 2)) {
            return;
        }

        long[][] adjList = new long[V][V];

        for (int edge = 0; edge < E; edge++) {
            int source = in.nextInt();
            int dest = in.nextInt();
            long weight = in.nextInt();

            if (!IsValid(source, 0, V - 1)) {
                return;
            }
            if (!IsValid(dest, 0, V - 1)) {
                return;
            }
            if (!IsValid(weight, 0, (long) Math.pow(10, 8))) {
                return;
            }

            adjList[source][dest] = weight;
            adjList[dest][source] = weight;
        }

        //printMatrix(V, adjList);

        long[][] newAdjList = null;

        //following floyd-warshall all-pairs shortest path
        for (int index = 0; index < V - 1; index++) {
            newAdjList = new long[V][V];
            for (int i = 0; i < V; i++) {
                for (int j = 0; j < V; j++) {
                    if (i == j) {
                        continue;
                    }
                    long bestpath = adjList[i][j]; // no path
                    for (int k = 0; k < V; k++) {
                        long newbestpath = 0;
                        if (adjList[i][k] != 0 && adjList[k][j] != 0) {
                            newbestpath = Math.min(adjList[i][k], adjList[k][j]);
                        }

                        if (newbestpath != 0) {
                            bestpath = Math.max(newbestpath, bestpath);
                        }
                    }

                    newAdjList[i][j] = bestpath;
                    newAdjList[j][i] = bestpath;
                }
            }

            adjList = newAdjList;
        }
        printMatrix(V, newAdjList);

        out.close();
        in.close();
    }

    private static void printMatrix(int V, long[][] newAdjList) {
        for (int i = 0; i < V; i++) {
            for (int j = 0; j < V; j++) {

                out.print(newAdjList[i][j]);

                if (j < V) {
                    out.print(" ");
                }
            }
            out.println();
        }
    }

    private static boolean IsValid(long actual, long low, long high) {
        if (actual < low || actual > high) {
            out.println("wrong");
            return false;
        }
        return true;
    }
}
