
/*************************************************************************
 * Name:  Arulkumar
 * Email: arul.subramaniam@hotmail.com
 *
 * Compilation:  javac MehtaAndCharmingStrings.java
 * Execution:
 * Dependencies:
 *
 * Description:
 *
 *************************************************************************/
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.util.StringTokenizer;
import org.omg.CORBA.INTERNAL;

/**
 *
 * @author Arulkumar
 * @email arul.subramaniam@hotmail.com
 */
class MehtaAndCharmingStrings {

    static PrintStream out = System.out;

    /**
     *
     * @param args
     */
    public static void main(String[] args) {

        InputReader Reader = new InputReader(System.in);

        String string = Reader.nextLine();

        int[] allowed = new int[string.length()];

        for (int i = 0; i < string.length(); i++) {
            allowed[i] = Reader.nextInt();
        }

        int[] count = getCharmOfString(string, allowed);

        for (int i = 0; i < string.length(); i++) {
            out.print(count[i]);
            if (i != string.length() - 1) {
                out.print(" ");
            }
        }

        out.println();
        out.close();
    }

    // Returns the minimum number of cuts needed to partition a string
// such that every part is a palindrome
    static int[] getCharmOfString(String str, int[] allowed) {
        // Get the length of the string
        int n = str.length();

        /* Create two arrays to build the solution in bottom up manner
        C[i] = Minimum number of cuts needed for palindrome partitioning
        of substring str[0..i]
        P[i][j] = true if substring str[i..j] is palindrome, else false
        Note that C[i] is 0 if P[0][i] is true */
        int[] C = new int[n];
        boolean[][] P = new boolean[n][n];

        int i, j, L; // different looping variables

        // Every substring of length 1 is a palindrome
        for (i = 0; i < n; i++) {
            P[i][i] = true;
        }

        /* L is substring length. Build the solution in bottom up manner by
        considering all substrings of length starting from 2 to n. */
        for (L = 2; L <= n; L++) {
            // For substring of length L, set different possible starting indexes
            for (i = 0; i < n - L + 1; i++) {
                j = i + L - 1; // Set ending index

                // If L is 2, then we just need to compare two characters. Else
                // need to check two corner characters and value of P[i+1][j-1]
                if (L == 2) {
                    P[i][j] = (str.charAt(i) == str.charAt(j));
                } else {
                    P[i][j] = (str.charAt(i) == str.charAt(j)) && P[i + 1][j - 1];
                }
            }
        }

        int[] charm = new int[n];
        for (i = 0; i < n; i++) {
            for (j = 0; j < allowed[i]; j++) {
                if (P[i][i + j] == true) {
                    charm[i] = Math.max(charm[i], j + 1);
                }
            }
        }

        // Return the min cut value for complete string. i.e., str[0..n-1]
        return charm;
    }

    /**
     *
     * @param substring
     * @return
     */
    private static boolean IsPalindrome(String substring) {
        boolean isPalin = true;
        int len = substring.length();
        for (int i = 0; i < len / 2; i++) {
            if (substring.charAt(i) != substring.charAt(len - 1 - i)) {
                isPalin = false;
                break;
            }
        }

        return isPalin;
    }

    /** Class for buffered reading int and double values */
    private static class InputReader {

        public BufferedReader reader;
        public StringTokenizer tokenizer;

        public InputReader(InputStream stream) {
            reader = new BufferedReader(new InputStreamReader(stream));
            tokenizer = null;
        }

        public String next() {
            while (tokenizer == null || !tokenizer.hasMoreTokens()) {
                try {
                    tokenizer = new StringTokenizer(reader.readLine());
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }
            return tokenizer.nextToken();
        }

        public int nextInt() {
            return Integer.parseInt(next());
        }

        public long nextLong() {
            return Long.parseLong(next());
        }

        public String nextLine() {
            try {
                return reader.readLine();
            } catch (IOException ex) {
                throw new RuntimeException(ex);
            }
        }
    }
}
