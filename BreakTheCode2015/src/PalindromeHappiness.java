
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.StringTokenizer;

/**
 *
 * @author Arulkumar
 */
class PalindromeHappiness {

    static PrintWriter out = new PrintWriter(System.out);
    static InputReader Reader = new InputReader(System.in);

    public static void main(String[] args) {

        int numtests = Reader.nextInt();
        for (int i = 0; i < numtests; i++) {
            String str = Reader.nextLine();
            out.println(getCharsToPalindrome(str) <= 1 ? "yes" : "no");
            out.flush();
        }

        out.close();
    }

    public static double round(double value, int places) {
        if (places < 0) {
            throw new IllegalArgumentException();
        }

        BigDecimal bd = new BigDecimal(value);
        bd = bd.setScale(places, RoundingMode.HALF_UP);
        return bd.doubleValue();
    }

    private static int getCharsToPalindrome(String str) {
        int len = str.length();
        if (len <= 1) {
            return 0;
        }

        int numchars = 0;
        for (int i = 0; i < len / 2; i++) {
            if (str.charAt(i) != str.charAt(len - i - 1)) {
                numchars++;

                if (numchars >= 2) {
                    break;
                }
            }
        }

        return numchars;
    }

    /**
     * Class for buffered reading int and double values
     */
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

        public float nextFloat() {
            return Float.parseFloat(next());
        }
    }

}
