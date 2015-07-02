
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.util.StringTokenizer;

/**
 *
 * @author Arulkumar
 */
class ChefsStrings {

    static PrintWriter out = new PrintWriter(System.out);
    static InputReader Reader = new InputReader(System.in);

    public static void main(String[] args) {
        int tests = Reader.nextInt();

        for (int test = 0; test < tests; test++) {
            String input = Reader.nextLine();
            int aCount = 0;
            int bCount = 0;
            for (char ch : input.toCharArray()) {
                if (ch == 'a') {
                    aCount++;
                } else {
                    bCount++;
                }
            }

            int result = 0;

            int totalab = (aCount + bCount);
            //characters to be added
            if (totalab % 9 != 0) {
                int nearest9 = (aCount + bCount) / 9;
                totalab = (nearest9 + 1) * 9;
                result += (totalab - (aCount + bCount));
            }

            int aNeeded = (4 * totalab) / 9;
            int bNeeded = (5 * totalab) / 9;

            if (aCount > aNeeded) {
                result += (aCount - aNeeded);
            }

            if (bCount > bNeeded) {
                result += (bCount - bNeeded);
            }
            
            out.println(result);

            out.flush();
        }

        out.close();
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
    }
}
