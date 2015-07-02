
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.StringTokenizer;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
/*************************************************************************
 * Name:  Arulkumar
 * Email: arul.subramaniam@hotmail.com
 *
 * Compilation:  javac DateWithAvni.java
 * Execution:
 * Dependencies:
 *
 * Description:
 *
 *************************************************************************/
public class DateWithAvni {

    static PrintWriter out = new PrintWriter(System.out);
    static InputReader Reader = new InputReader(System.in);

    public static void main(String[] args) {
        int numTests = Reader.nextInt();
        for (int index = 0; index < numTests; index++) {
            String str = Reader.nextLine();

            boolean isPassed = true;

            for (int i = 0; i < str.length() - 1; i++) {
                if (str.charAt(i) == str.charAt(i + 1)) {
                    out.println("SLAP");
                    isPassed = false;
                    break;
                }
            }

            if (isPassed) {
                out.println("KISS");
            }

            out.flush();
        }

        out.close();
    }

    /** Class for buffered reading int and double values */
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
