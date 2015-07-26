
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.StringTokenizer;


/**
 *
 * @author Arulkumar
 */
class GreedyPuppy {
 
    public static void main(String[] args)
    {
        InputReader in = new InputReader(System.in);
        int tests = in.nextInt();

        for (int test = 0; test < tests; test++) {
            int N = in.nextInt();
            int K = in.nextInt();
            
            int maxCoins = N % K;
            K--;
            
            while(K != 0 && maxCoins < (N % K))
            {
                maxCoins = (N % K);
                K--;
            }
            
            System.out.println(maxCoins);
            System.out.flush();
        }
    }
    
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