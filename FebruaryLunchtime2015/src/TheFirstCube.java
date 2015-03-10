
import java.math.BigInteger;
import java.util.Scanner;

/*************************************************************************
 * Name:  Arulkumar
 * Email: arul.subramaniam@hotmail.com
 *
 * Compilation:  javac TheFirstCube.java
 * Execution:
 * Dependencies:
 *
 * Description:
 *
 * THANKS:  http://burningmath.blogspot.in/2013/09/how-to-know-or-check-if-number-is.html
 *************************************************************************/
class TheFirstCube {

    private static Scanner scanner;

    public static void main(String[] args) {

        scanner = new Scanner(System.in);

        long numOfTests = scanner.nextInt();

        for (int index = 0; index < numOfTests; index++) {
            // get the number of digits
            int N = scanner.nextInt();

            BigInteger S = BigInteger.ONE;

            // get all the digits and
            // get the multiplication of all the digits
            for (int idx = 0; idx < N; idx++) {
                BigInteger num = scanner.nextBigInteger();

                S = S.multiply(num);
            }

            // for all the S, 2S, 3S.. find if it is a perfect cube
            long count = 1;

            while (count != 0) {
                BigInteger currentSeries = S.multiply(BigInteger.valueOf(count));

                int digitalRoot = getDigitalRoot(currentSeries);
                int mod3 = currentSeries.mod(BigInteger.valueOf(3)).intValue();

                if ((digitalRoot == 9 && mod3 == 0) || (digitalRoot == 8 && mod3 == 2) || (digitalRoot == 1 && mod3 == 1)) {
                    System.out.println(currentSeries.mod(BigInteger.valueOf(1000000007)));
                    break;
                }

                count++;
            }
        }
    }

    private static int getDigitalRoot(BigInteger currentSeries) {
        if (currentSeries.compareTo(BigInteger.TEN) < 0) {
            return currentSeries.intValue();
        }
        return getDigitalRoot(currentSeries.divide(BigInteger.TEN)) + getDigitalRoot(currentSeries.mod(BigInteger.TEN));
    }

    /**
     *
     * @param actual
     * @param lowrange
     * @param highrange
     * @return
     */
    private static boolean isValidRange(BigInteger actual, BigInteger lowrange, BigInteger highrange) {
        if (actual.compareTo(lowrange) < 0  || actual.compareTo(highrange) > 0) {
            System.out.println("wrong!");
            return false;
        }

        return true;

    }
}
