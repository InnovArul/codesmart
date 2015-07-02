
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.util.Scanner;
import java.util.StringTokenizer;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
/*************************************************************************
 * Name:  Arulkumar
 * Email: arul.subramaniam@hotmail.com
 *
 * Compilation:  javac DatingGame.java
 * Execution:
 * Dependencies:
 *
 * Description:
 *
 *************************************************************************/
class DatingGame {

    static PrintWriter out = new PrintWriter(System.out);
    static Scanner Reader = new Scanner(System.in);

    public static void main(String[] args) {
        int numTests = Reader.nextInt();
        for (int index = 0; index < numTests; index++) {

            int N = Reader.nextInt();

            BigInteger max = BigInteger.valueOf(-1), secondmax = BigInteger.valueOf(-1);
            int pileNum = 0;

            for (int i = 0; i < N; i++) {
                BigInteger pileCoins = Reader.nextBigInteger();

                if (max.equals(BigInteger.valueOf(-1))) {
                    max = pileCoins;
                    pileNum = i + 1;
                } else {
                    if (pileCoins.compareTo(max) > 0) {
                        secondmax = max;
                        max = pileCoins;
                        pileNum = i + 1;
                    } else {
                        if (pileCoins.compareTo(secondmax) > 0) {
                            secondmax = pileCoins;
                        }
                    }
                }
            }

            String str = "";
            if (max.equals(BigInteger.valueOf(-1)) || max.equals(secondmax)) {
                str = "NO";
            } else {
                if (secondmax.equals(BigInteger.valueOf(-1))) {
                    str = "NO";
                } else {
                    str = "YES " + pileNum + " ";
                    if (secondmax.equals(BigInteger.ZERO)) {
                        str += 1;
                    } else {
                        str += secondmax;
                    }
                }
            }

            out.println(str);
            out.flush();

        }


        out.close();
    }
}
