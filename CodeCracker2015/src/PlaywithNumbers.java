
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;

/**
 *
 * @author Arulkumar
 */
class PlaywithNumbers {

    static PrintWriter out = new PrintWriter(System.out);
    static InputReader Reader = new InputReader(System.in);

    public static void main(String[] args) {
        int N = Reader.nextInt();
        int K = Reader.nextInt();

        Map<Integer, Integer> exists = new HashMap<>();
        int count = 0;
        for (int i = 0; i < N; i++) {
            int num = Reader.nextInt();

            if ((num % 2) == 0) {
                continue;
            }
            if (num >= K) {
                continue;
            }

            if (!exists.containsKey(num)) {
                count++;
                exists.put(num, 1);
            } 
        }

        out.println(count);
        out.flush();
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

        public long nextUnsignedLong() {
            return Long.parseUnsignedLong(next());
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
