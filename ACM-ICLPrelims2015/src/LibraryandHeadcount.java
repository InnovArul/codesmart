
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

/*************************************************************************
 * Name:  Arulkumar
 * Email: arul.subramaniam@hotmail.com
 *
 * Compilation:  javac LibraryandHeadcount.java
 * Execution:
 * Dependencies:
 *
 * Description:
 *
 *************************************************************************/
class LibraryandHeadcount {

    private static Scanner in = null;
    private static PrintWriter out = null;

    public static void main(String[] args) {
        in = new Scanner(System.in);
        out = new PrintWriter(System.out);
        Map<String, Integer> nameHash = new HashMap<String, Integer>();

        int numTests = in.nextInt();

        if (!IsValid(numTests, 1, 10)) {
            return;
        }

        for (int index = 0; index < numTests; index++) {
            nameHash.clear();
            // get number of names
            int numNames = in.nextInt();
            if (!IsValid(numNames, 1, 50000)) {
                return;
            }

            for (int nameIdx = 0; nameIdx < numNames; nameIdx++) {
                String name = in.next();

                if (!IsValid(name.length(), 1, 30)) {
                    return;
                }

                if (!nameHash.containsKey(name)) {
                    nameHash.put(name, 1);
                } else {
                    nameHash.remove(name);
                }
            }

            out.println(nameHash.size());
        }

        in.close();
        out.close();
    }

    private static boolean IsValid(long actual, long low, long high) {
        if (actual < low || actual > high) {
            out.println("wrong");
            return false;
        }
        return true;
    }
}
