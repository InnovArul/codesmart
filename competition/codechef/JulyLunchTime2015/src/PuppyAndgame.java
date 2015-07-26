
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.StringTokenizer;


/**
 *
 * @author Arulkumar
 */
class PuppyAndgame {
 
    public static void main(String[] args)
    {
        InputReader in = new InputReader(System.in);
        int tests = in.nextInt();

        for (int test = 0; test < tests; test++) {
            int A = in.nextInt();
            int B = in.nextInt();
          
            int min = Math.min(A, B);
            int max = Math.max(A, B);
            
            if(min == 1 && max == 1)
            {
                System.out.println("Vanka");
            }
            else
            {
                int current = max;
                if(current % 2 == 1)
                {
                    System.out.println("Vanka");
                }
                else
                {
                    System.out.println("Tuzik");
                }
            }
            
            
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