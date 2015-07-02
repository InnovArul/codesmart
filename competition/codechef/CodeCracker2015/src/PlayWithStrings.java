
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.StringTokenizer;

/**
 *
 * @author Arulkumar
 */
class PlaywithStrings {

    static PrintWriter out = new PrintWriter(System.out);
    static InputReader Reader = new InputReader(System.in);

    public static void main(String[] args) {
        int N = Reader.nextInt();

        for (int i = 0; i < N; i++) {
            String str = Reader.nextLine();

            int numOfSubs = 0;

            Map<Character, ArrayList<Integer>> source = new HashMap<>();

            for (int j = 0; j < str.length(); j++) {
                char ch = str.charAt(j);
                numOfSubs++;
                if (source.containsKey(ch)) {
                    for (Integer index : source.get(ch)) {
                        if ((j - index + 1) % 2 == 1) {
                            numOfSubs++;
                        }
                    }

                    source.get(ch).add(j);
                } else {
                    ArrayList<Integer> arr = new ArrayList<>();
                    arr.add(1);
                    source.put(ch, arr);
                }
            }

            // now look for odd length strings
            out.println(numOfSubs);
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
