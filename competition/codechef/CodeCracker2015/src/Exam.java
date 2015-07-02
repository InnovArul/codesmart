
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.StringTokenizer;

/**
 *
 * @author Arulkumar
 */
class Exam {

    static PrintWriter out = new PrintWriter(System.out);
    static InputReader Reader = new InputReader(System.in);
    final static int REMOVE_NUMBER = -1;

    public static void main(String[] args) {
        int T = Reader.nextInt();

        for (int i = 0; i < T; i++) {

            int N = Reader.nextInt();
            int K = Reader.nextInt();

            int[] numbers = new int[N];

            ArrayList<Integer> source = new ArrayList<>();
            int sofar = 0;
            for (int j = 0; j < N; j++) {
                int num = Reader.nextInt();

                insertIntoArray(source, numbers, j, K);

            }

            out.println();
            out.flush();
        }

        out.close();

    }

    private static int insertIntoArray(ArrayList<Integer> source, int[] numbers, int currIndex, int Kneeded) {
        int highest = source.get(source.size() - 1);
        
        if (highest < numbers[currIndex]) {
            return REMOVE_NUMBER;
        }

        int currNumber = numbers[currIndex];
        for (int i = 0; i < currIndex; i++) {
           // if(currNumber + numbers[i] < source.get(source.size() - 1)
        }
        
        return 0;
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
