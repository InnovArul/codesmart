
import java.math.BigInteger;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Scanner;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
/*************************************************************************
 * Name:  Arulkumar
 * Email: arul.subramaniam@hotmail.com
 *
 * Compilation:  javac Examtime.java
 * Execution:
 * Dependencies:
 *
 * Description:
 *
 *************************************************************************/
class Examtime {

    private static Scanner scann = null;

    public static void main(String[] args) {
        long mod = 1000000007;
        long[] dp = new long[1000001];
        dp[0] = 0;
        dp[1] = 1;
        dp[2] = 1;
        for (int n = 3; n < dp.length; n++) {
            dp[n] = (dp[n - 2] + dp[n - 3]) % mod;
        }

        scann = new Scanner(System.in);

        long numOfTests = scann.nextLong();

        if (!isValidRange(numOfTests, 1, (long) Math.pow(10, 5))) {
            return;
        }

        for (long index = 0; index < numOfTests; index++) {

            long count = scann.nextLong();
            if (!isValidRange(count, 1, (long) Math.pow(10, 6))) {
                return;
            }

            System.out.println(dp[(int)count] + dp[(int)count - 1] % mod);
        }
    }

    /**
     *
     * @param actual
     * @param lowrange
     * @param highrange
     * @return
     */
    private static boolean isValidRange(long actual, long lowrange, long highrange) {
        if (actual < lowrange || actual > highrange) {
            System.out.println("wrong!");
            return false;
        }

        return true;

    }
}
