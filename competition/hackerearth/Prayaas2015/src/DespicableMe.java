
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.SortedMap;
import java.util.StringTokenizer;
import java.util.TreeMap;

/**
 *
 * @author Arulkumar
 */
class DespicableMe {

    static PrintWriter out = new PrintWriter(System.out);
    static InputReader Reader = new InputReader(System.in);

    public static void main(String[] args) {
        int N = Reader.nextInt();
        int[] s1 = new int[N];
        int[] s2 = new int[N];

        for (int i = 0; i < N; i++) {
            s1[i] = Reader.nextInt();
        }

        for (int i = 0; i < N; i++) {
            s2[i] = Reader.nextInt();
        }

        int nQuery = Reader.nextInt();

        for (int i = 0; i < nQuery; i++) {
            int a = Reader.nextInt();
            int b = Reader.nextInt();
            int c = Reader.nextInt();
            int d = Reader.nextInt();

            SortedMap<Integer, Integer> source = new TreeMap<>();

            for (int j = a - 1; j < (((a + b) < s1.length) ? (a + b) : s1.length); j++) {
                source.put(s1[j], 1);
            }

            SortedMap<Integer, Integer> secondary = new TreeMap<>();
            SortedMap<Integer, Integer> deleted = new TreeMap<>();
            for (int j = c - 1; j < (((c + d) < s2.length) ? (c + d) : s2.length); j++) {

                if (deleted.containsKey(s2[j])) {
                    continue;
                }

                if (source.containsKey(s2[j])) {
                    deleted.put(s2[j], -1);
                    source.remove(s2[j]);
                } else {
                    secondary.put(s2[j], 1);
                }
            }
            out.println(secondary.size() + source.size());

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
