
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.math.BigInteger;
import java.util.StringTokenizer;

/*************************************************************************
 * Name:  Arulkumar
 * Email: arul.subramaniam@hotmail.com
 *
 * Compilation:  javac Lashker_e_Trishul.java
 * Execution:
 * Dependencies:
 *
 * Description:
 *
 *************************************************************************/
class Lashker_e_Trishul {

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
            long A = Reader.nextLong();
            if (!isValidRange(A, 1, (long) Math.pow(10, 9))) {
                return;
            }

            long B = Reader.nextLong();
            if (!isValidRange(B, 1, (long) Math.pow(10, 9))) {
                return;
            }

            long C = Reader.nextLong();
            if (!isValidRange(C, 1, (long) Math.pow(10, 6))) {
                return;
            }

            long P = Reader.nextLong();
            if (!isValidRange(P, 1, (long) Math.pow(10, 6))) {
                return;
            }

            int[] E = {1, 6, 9, 3, 6, 9, 3, 2, 9};

            int D_A = K(BigInteger.valueOf(A));
            int D_B = 1;
            int sumB = K(BigInteger.valueOf(B));


            int fAB = 0;

            if (sumB == 1) {
                D_B = 1;
            } else {
                D_B = (int) (B % E[sumB - 1]);
            }

            if (D_B == 1) {
                fAB = D_A;
            } else {
                if (D_A == 3 || D_A == 6 || D_A == 9) {
                    fAB = 9;
                } else {
                    fAB = K(BigInteger.valueOf((long) Math.pow(D_A, D_B)));
                }
            }

            long P_fAB = P + fAB;

            long numOfNumbers = P_fAB / C;

            out.println(numOfNumbers * (numOfNumbers - 1) / 2);

        }
        out.close();
    }

    //add all digits
    static int K(BigInteger x) {

        int s = 0;

        if (x.compareTo(BigInteger.valueOf(9)) <= 0) {
            return x.intValue();
        }

        while (x.compareTo(BigInteger.ZERO) != 0) {

            s = s + (x.remainder(BigInteger.TEN).intValue());
            x = x.divide(BigInteger.TEN);
        }

        if (s > 9) {
            s = K(BigInteger.valueOf(s));
        }

        return s;
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