
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
class FullRetard {
    
    static PrintWriter out = new PrintWriter(System.out);
    static InputReader Reader = new InputReader(System.in);
    
    public static void main(String[] args) {
        int numtests = Reader.nextInt();
        for (int i = 0; i < numtests; i++) {
            long number = Reader.nextLong();
            
            out.println(isPrime(number) ? "YES" : "NO");
            out.flush();
        }
        
        out.close();
    }
    
    public static boolean isPrime(long n) {
        if (n <= 3) {
            return n > 1;
        } else if (n % 2 == 0 || n % 3 == 0) {
            return false;
        } else {
            double sqrtN = Math.floor(Math.sqrt(n));
            for (int i = 5; i <= sqrtN; i += 6) {
                if (n % i == 0 || n % (i + 2) == 0) {
                    return false;
                }
            }
            return true;
        }
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
