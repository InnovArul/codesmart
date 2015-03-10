
import java.io.PrintWriter;
import java.util.Scanner;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
/*************************************************************************
 * Name:  Arulkumar
 * Email: arul.subramaniam@hotmail.com
 *
 * Compilation:  javac MiceandFoodConsumption.java
 * Execution:
 * Dependencies:
 *
 * Description:
 *
 *************************************************************************/
class MiceandFoodConsumption {

    private static Scanner in = null;
    private static PrintWriter out = null;
    static long[] cupcakes = new long[10001];

    public static void main(String[] args) {
        in = new Scanner(System.in);
        out = new PrintWriter(System.out);


        cupcakes[1] = 0;
        cupcakes[2] = 2;
        cupcakes[3] = 2;

        for (int index = 4; index < 10001; index++) {
            long numGroups = getNumberOf23Groups(index - 3);

            if (numGroups < 3) {
                numGroups++;
            }

            cupcakes[index] = 2 + numGroups;
        }

        int numTests = in.nextInt();

        if (!IsValid(numTests, 1, 100)) {
            return;
        }

        for (int index = 0; index < numTests; index++) {
            int mice = in.nextInt();

            if (!IsValid(mice, 1, 10000)) {
                return;
            }

            out.println(cupcakes[mice]);
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

    private static long getNumberOf23Groups(int miceNumber) {
        if (miceNumber <= 0) {
            return 0;
        }
        return 1 + getNumberOf23Groups(miceNumber - 3);
    }
}
