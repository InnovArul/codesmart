
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.util.StringTokenizer;

/*************************************************************************
 * Name:  Arulkumar
 * Email: arul.subramaniam@hotmail.com
 *
 * Compilation:  javac ChefuandBilli.java
 * Execution:
 * Dependencies:
 *
 * Description:
 *
 *************************************************************************/
class ChefuandBilli {

    private static PrintStream out = System.out;

    public static void main(String[] args) throws IOException {

        Reader.init(System.in);

        // get number of tests
        int numTests = Reader.nextInt();

        if (!isValidRange(numTests, 1, 10)) {
            return;
        }

        for (int idx = 0; idx < numTests; idx++) {
            //get number of points
            int N = Reader.nextInt();
            if (!isValidRange(N, 1, 400000)) {
                return;
            }

            long[] A = new long[N];
            long[] B = new long[N];

            for (int i = 0; i < N; i++) {
                A[i] = Reader.nextLong();
                if (!isValidRange(A[i], 0, (long) Math.pow(10, 9))) {
                    return;
                }
            }

            for (int i = 0; i < N; i++) {
                B[i] = Reader.nextLong();
                if (!isValidRange(B[i], 0, A[i])) {
                    return;
                }
            }

            long D = Reader.nextInt();
            if (!isValidRange(D, 1, (long) Math.pow(10, 9))) {
                return;
            }

            long minSteps = Integer.MAX_VALUE, index = Integer.MAX_VALUE;
            for (int i = 0; i < N; i++) {
                if (A[i] - B[i] > 0) {
                    long totalSteps = A[i] + B[i]; // for A[i] + B[i] steps, the boy will reach A[i] - B[i] steps
                    long neededSteps = D - A[i];
                    long neededCount = (long) Math.ceil((double) neededSteps / ((A[i] - B[i]) * 1.0));
                    long cumulativeSteps = (neededCount * totalSteps) + A[i];

                    long correctedSteps = cumulativeSteps - (((neededCount * (A[i] - B[i])) + A[i]) - D);

                    //out.println(correctedSteps);
                    //long correctedSteps = cumulativeSteps - (cumulativeSteps - )
                    if (correctedSteps < minSteps) {
                        minSteps = cumulativeSteps;
                        index = i;
                    }
                }
            }

            out.println(index + 1);
        }
        out.close();
    }

    private static boolean isValidRange(long actual, long lowrange, long highrange) {
        if (actual < lowrange || actual > highrange) {
            System.out.println("wrong!");
            return false;
        }

        return true;

    }

    /**
     * THANKS: http://www.cpe.ku.ac.th/~jim/java-io.html
     */
    /** Class for buffered reading int and double values */
    static class Reader {

        static BufferedReader reader;
        static StringTokenizer tokenizer;

        /** call this method to initialize reader for InputStream */
        static void init(InputStream input) {
            reader = new BufferedReader(
                    new InputStreamReader(input));
            tokenizer = new StringTokenizer("");
        }

        /** get next word */
        static String next() throws IOException {
            while (!tokenizer.hasMoreTokens()) {
                //TODO add check for eof if necessary
                tokenizer = new StringTokenizer(
                        reader.readLine());
            }
            return tokenizer.nextToken();
        }

        static int nextInt() throws IOException {
            return Integer.parseInt(next());
        }

        static double nextDouble() throws IOException {
            return Double.parseDouble(next());
        }

        static long nextLong() throws IOException {
            return Long.parseLong(next());
        }
    }
}
