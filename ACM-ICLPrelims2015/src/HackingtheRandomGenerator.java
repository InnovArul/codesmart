
import java.io.PrintWriter;
import java.util.Scanner;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
/*************************************************************************
 * Name:  Arulkumar
 * Email: arul.subramaniam@hotmail.com
 *
 * Compilation:  javac HackingtheRandomGenerator.java
 * Execution:
 * Dependencies:
 *
 * Description:
 *
 *************************************************************************/
class HackingtheRandomGenerator {

    private static Scanner in = null;
    private static PrintWriter out = null;
    static int[] sequence1;
    static int[] sequence2;
    static int K;

    public static void main(String[] args) {
        in = new Scanner(System.in);

        int numTests = in.nextInt();

        if (!IsValid(numTests, 1, 10)) {
            return;
        }

        for (int index = 0; index < numTests; index++) {
            int N = in.nextInt();
            if (!IsValid(N, 1, 100000)) {
                return;
            }

            K = in.nextInt();
            if (!IsValid(K, 1, N)) {
                return;
            }

            sequence1 = new int[K];
            sequence2 = new int[K];

            //get two sequences
            for (int i = 0; i < K; i++) {
                sequence1[i] = in.nextInt();
            }

            for (int i = 0; i < K; i++) {
                sequence2[i] = in.nextInt();
            }

            int largestSequence;
            int[] X = new int[K + 1];
            int[] Y = new int[K + 1];

            for (int i = K-1; i>=0; i--) {
                for (int j = K-1; j>=0 ; j--) {
                    if (sequence1[i] == sequence2[j]) {
                        X[j] = 1 + Y[j + 1];
                    } else {
                        X[j] = Math.max(Y[j], X[j + 1]);
                    }
                }
                Y = X.clone();
            }
            System.out.println(X[0]);
        }
        in.close();
    }

    private static boolean IsValid(long actual, long low, long high) {
        if (actual < low || actual > high) {
            System.out.println("wrong!");
            return false;
        }
        return true;
    }
}
