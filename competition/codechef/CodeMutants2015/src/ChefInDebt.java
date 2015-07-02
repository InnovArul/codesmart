
import java.math.BigInteger;
import java.util.Comparator;
import java.util.PriorityQueue;
import java.util.Scanner;

/*************************************************************************
 * Name:  Arulkumar
 *
 * Compilation:  javac ChefInDebt.java
 * Execution:
 * Dependencies:
 *
 * Description:
 *
 *************************************************************************/
class ChefInDebt {

    private static class Lender {

        int index;
        String name;
        int amount;

        public Lender(int index, String name, int amount) {
            this.index = index;
            this.name = name;
            this.amount = amount;
        }

        @Override
        public boolean equals(Object o) {
            Lender obj = (Lender) o;
            if (obj.amount == amount) {
                return true;
            }
            return false;
        }
    }

    private static class minHeapComparator implements Comparator<Lender> {

        @Override
        public int compare(Lender o1, Lender o2) {
            if (o2.amount == o1.amount) {
                return o1.index - o2.index;
            } else {
                return o1.amount - o2.amount;
            }
        }
    }

    private static class maxHeapComparator implements Comparator<Lender> {

        @Override
        public int compare(Lender o1, Lender o2) {
            if (o2.amount == o1.amount) {
                return o1.index - o2.index;
            } else {
                return o2.amount - o1.amount;
            }
        }
    }
    private static Scanner scann = null;

    public static void main(String[] args) {
        scann = new Scanner(System.in);
        String[] names = {"Dhaval", "Shivang", "Bhardwaj", "Rishab", "Maji",
            "Gaurav", "Dhruv", "Nikhil", "Rohan", "Ketan"};

        PriorityQueue<Lender> maxQ = new PriorityQueue<Lender>(10, new maxHeapComparator());
        PriorityQueue<Lender> minQ = new PriorityQueue<Lender>(10, new minHeapComparator());

        for (int index = 0; index < 10; index++) {
            BigInteger amount = scann.nextBigInteger();
            if (!isValidRange(amount, BigInteger.valueOf(1), BigInteger.valueOf((int) Math.pow(10, 5)))) {
                return;
            }

            Lender current = new Lender(index, names[index], amount.intValue());
            maxQ.add(current);
            minQ.add(current);

        }

        for (int index = 0; index < 5; index++) {
            Lender max = maxQ.remove();

            //remove max from minQ
            minQ.remove(max);

            Lender min = minQ.remove();

            maxQ.remove(min);

            if (max.equals(min)) {
                if (max.index < min.index) {
                    System.out.println(max.name);
                    System.out.println(min.name);
                } else {
                    System.out.println(min.name);
                    System.out.println(max.name);
                }
            } else {
                System.out.println(max.name);
                System.out.println(min.name);
            }
        }

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
