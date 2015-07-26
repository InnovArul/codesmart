
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;

/**
 *
 * @author Arulkumar
 */
 class PalinPairs {
     
     public static void main(String[] args)
     {
         InputReader in = new InputReader(System.in);
         int numStrings = in.nextInt();
         
         String[] strs = new String[numStrings];
         
         HashMap<String, ArrayList<Integer>> strHash = strHash = new HashMap<String, ArrayList<Integer>>();
         
         for (int index = 0; index < numStrings; index++) {
             String str = in.next();
             if(strHash.containsKey(str))
             {
                 strHash.get(str).add(index);
             }
             else{
                 ArrayList<Integer> arr = new ArrayList<Integer>();
                 arr.add(index);
                 strHash.put(str, arr);
             }
         }
         
         int palinPairs = 0;
         
         for (Map.Entry<String, ArrayList<Integer>> entry : strHash.entrySet()) {
             String key = entry.getKey();
             String reverse = new StringBuffer(key).reverse().toString();
             
             if(strHash.containsKey(reverse)) {
                 ArrayList<Integer> list1 = entry.getValue();
                 ArrayList<Integer> list2 = strHash.get(reverse);
                 
                 palinPairs += getValidPairCount(list1, list2);
                 
             }
         }
         
         System.out.println(palinPairs);
         System.out.flush();
     }
     
     static int getValidPairCount(ArrayList<Integer> list1, ArrayList<Integer> list2)
     {
         int count = 0;
         for (Integer idx : list1) {
             int firstIndex = idx;
             int index = 0;
             while(index < list2.size() && firstIndex >= list2.get(index))
             {
                 index++;
             }
             
             count += list2.size() - index;
         }
         return count;
         
     }
     
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
    

