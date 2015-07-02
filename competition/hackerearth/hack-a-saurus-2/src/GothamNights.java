
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.StringTokenizer;

/**
 *
 * @author Arulkumar
 */
class GothamNights {

    static PrintWriter out = new PrintWriter(System.out);
    static InputReader Reader = new InputReader(System.in);

    public static void main(String[] args) {

        int numtests = Reader.nextInt();
        for (int i = 0; i < numtests; i++) {
            long number = Reader.nextLong();

            
            // [(log(2πn)/2+n(logn−loge))/log10]+1
            long digits = (long) Math.ceil(((Math.log(2 * Math.PI * number) / 2) + (number * (Math.log(number) - Math.log(Math.exp(1))))) / Math.log(10));

            if(number == 0) {
                digits = 1;
            }
            out.println(digits);
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
