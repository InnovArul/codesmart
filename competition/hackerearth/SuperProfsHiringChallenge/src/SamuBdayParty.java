
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.StringTokenizer;


/**
 *
 * @author Arulkumar
 */
class SamuBdayParty {
    public static void main(String[] args)
    {
        InputReader in = new InputReader(System.in);
        int tests = in.nextInt();
        
        for (int test = 0; test < tests; test++) {
            int Friends = in.nextInt();
            int Dishes = in.nextInt();
            
            int totalPref = 0;
            
            for (int friend = 0; friend < Friends; friend++) {
                String currentPref = in.next();
                totalPref |= Integer.parseInt(currentPref, 2);
            }
            
            int dishcount = 0;
            
            for(char ch : Integer.toBinaryString(totalPref).toCharArray())
            {
                if(ch == '1') dishcount++;
            }
            
            System.out.println(dishcount);
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

        public String nextLine() {
            try {
                return reader.readLine();
            } catch (IOException ex) {
                throw new RuntimeException(ex);
            }
        }
    }
}
