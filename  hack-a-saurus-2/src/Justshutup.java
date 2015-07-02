
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
class Justshutup {

    static PrintWriter out = new PrintWriter(System.out);
    static InputReader Reader = new InputReader(System.in);

    public static void main(String[] args) {
        int numtests = Reader.nextInt();
        final int totalnumbers = 1000000;

        int[] lastdigits = new int[totalnumbers];
        lastdigits[0] = 1;

        for (int j = 1; j < totalnumbers; j++) {
            lastdigits[j] = getLastTwoDigits(j, lastdigits[j - 1]);
        }

        for (int i = 0; i < numtests; i++) {
            int number = Reader.nextInt();

            out.println(lastdigits[number] % 10);
            out.flush();
        }

        out.close();
    }

    private static int getLastTwoDigits(int current, int previous) {

        //eliminate all 0s
        while (current % 10 == 0) {
            current = current / 10;
        }

        Integer currMult = current * previous;

        while (currMult % 10 == 0) {
            currMult = currMult / 10;
        }
        
        String currMultStr = currMult.toString();
        if (currMultStr.length() > 3) {
            currMultStr = currMultStr.substring(currMultStr.length() - 3);
            currMult = Integer.parseInt(currMultStr);
        }

        return currMult;
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
