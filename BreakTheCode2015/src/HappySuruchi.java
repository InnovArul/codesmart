
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayDeque;
import java.util.Queue;
import java.util.StringTokenizer;

/**
 *
 * @author Arulkumar
 */
class HappySuruchi {

    static PrintWriter out = new PrintWriter(System.out);
    static InputReader Reader = new InputReader(System.in);

    public static void main(String[] args) {

        int numtests = Reader.nextInt();
        for (int i = 0; i < numtests; i++) {
            int N = Reader.nextInt();
            int A = Reader.nextInt();
            int B = Reader.nextInt();

            int[][] adjMatrix = new int[N + 1][N + 1];

            for (int j = 0; j < N - 1; j++) {
                int loc1 = Reader.nextInt();
                int loc2 = Reader.nextInt();

                adjMatrix[loc1][loc2] = 1;
                adjMatrix[loc2][loc1] = 1;
            }

            int shortPath = getShortestPath(adjMatrix, A, B, N);
            out.println(shortPath);
            out.flush();
        }

        out.close();
    }

    private static int getShortestPath(int[][] adjMatrix, int A, int B, int N) {
        boolean[] isVisited = new boolean[N + 1];

        int length = 0;

        Queue<Integer[]> queue = new ArrayDeque<>();
        queue.add(new Integer[]{A, 0});
        isVisited[A] = true;
        boolean isSuccess = false;

        while (!queue.isEmpty()) {
            Integer[] array = queue.remove();

            for (int i = 1; i <= N; i++) {

                if ((adjMatrix[array[0]][i] == 1) && (isVisited[i] == false)) {
                    queue.add(new Integer[]{i, array[1] + 1});

                    if (i == B) {
                        length = array[1] + 1;
                        isSuccess = true;
                        break;
                    }
                    
                    isVisited[i] = true;
                }
            }

            if (isSuccess) {
                break;
            }
        }

        return length;
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

        public float nextFloat() {
            return Float.parseFloat(next());
        }
    }

}
