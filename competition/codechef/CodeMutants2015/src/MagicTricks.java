
import java.util.Scanner;

/*************************************************************************
 * Name:  Arulkumar
 *
 * Compilation:  javac MagicTricks.java
 * Execution:
 * Dependencies:
 *
 * Description:
 *
 *************************************************************************/
class MagicTricks {

    private static Scanner scann = null;

    public static void main(String[] args) {
        scann = new Scanner(System.in);
        String input = scann.nextLine();
        if (!isValidRange(input.length(), 1, (int) Math.pow(10, 5))) {
            return;
        }

        if (input.compareTo(input.toLowerCase()) != 0) {
            System.out.println(0);
            return;
        }

        int numberOfQueries = scann.nextInt();
        if (!isValidRange(numberOfQueries, 1, (int) Math.pow(10, 6))) {
            return;
        }

        for (int index = 0; index < numberOfQueries; index++) {

            char character = scann.next(".").charAt(0);
            int leftRange = scann.nextInt();
            if (!isValidRange(leftRange, 1, input.length())) {
                return;
            }
            int rightRange = scann.nextInt();
            if (!isValidRange(numberOfQueries, 1, input.length())) {
                return;
            }

            if (leftRange > rightRange) {
                System.out.println(0);
                return;
            }

            String subString = input.substring(leftRange - 1, rightRange);
            int replacedStringLen = subString.replaceAll("[" + character + "]", "").length();
            int totalChars = subString.length() - replacedStringLen;
            System.out.println(totalChars);
        }
    }

    /**
     * to check the valid range
     * @param actual
     * @param lowrange
     * @param highrange
     * @return
     */
    private static boolean isValidRange(int actual, int lowrange, int highrange) {
        if (actual < lowrange || actual > highrange) {
            System.out.println(0);
            return false;
        }

        return true;
    }
}
