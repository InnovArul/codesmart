using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

class DevuClass
{

    /// Similar to Java.util.scanner class
    ///
    static class Scanner
    {
        ///
        /// variable to hold tokens
        ///
        internal static Queue<string> tokens = new Queue<string>();
        internal static StreamReader reader = new StreamReader(Console.OpenStandardInput());

        /// API to return next token
        ///
        ///
        internal static string next()
        {
            if (tokens.Count <= 0)
            {
                // read the whole line and split into tokens
                string[] toks = reader.ReadLine().Split();
                foreach (var tok in toks)
                {
                    tokens.Enqueue(tok);
                }

            }

            // return the token at front
            return tokens.Dequeue();
        }

        ///

        /// to return the integer which is available next in the console
        ///
        ///
        internal static int nextInt()
        {
            int integer = 0;

            while (!int.TryParse(next(), out integer))
            {

            }
            return integer;
        }

        ///

        /// read and return the next line from console
        ///
        ///
        internal static string nextLine()
        {
            return reader.ReadLine();
        }

        ///

        /// read and return next empty line from the console
        ///
        ///
        internal static string nextNonEmptyLine()
        {
            string str = reader.ReadLine();

            while (str.Trim().Equals(""))
            {
                str = reader.ReadLine();
            }
            return str;
        }
    }

    static void Main(string[] args)
    {
        int NumTests = Scanner.nextInt();

        for (int i = 0; i < NumTests; i++)
        {
            int type = Scanner.nextInt();
            String str = Scanner.nextLine();

            int Goccurence = str.Length - str.Replace("G", "").Length;
            int Boccurence = str.Length - Goccurence;

            long cost = 0;

            if (Math.Abs(Goccurence - Boccurence) >= 2)
            {
                cost = -1;
            }
            else
            {
                //determine first character
                char[] chars = new char[2];
                if (Goccurence == Boccurence)
                {
                    chars[0] = str[0];
                    chars[1] = (chars[0] == 'G') ? 'B' : 'G';
                }
                else if (Goccurence < Boccurence)
                {
                    chars[0] = 'B';
                    chars[1] = 'G';
                }
                else
                {
                    chars[0] = 'G';
                    chars[1] = 'B';
                }

                cost = getMinCost(str, chars, type);
            }

            Console.WriteLine(cost);

        }

       // Console.ReadKey();

    }

    private static long getMinCost(string str, char[] chars, int type)
    {
        double cost = 0;

        StringBuilder arrangement = new StringBuilder(str);
        long loopcount = str.Length;
        int compareChar = 0;

        for (int i = 0; i < loopcount - 1; i++)
        {
            if (arrangement[i] != chars[compareChar])
            {
                char temp = arrangement[i];
                int nextOtherCharPos = nextOtherChar(arrangement.ToString(), i + 1, chars[compareChar]);
                arrangement[i] = arrangement[nextOtherCharPos];
                arrangement[nextOtherCharPos] = temp;

                cost += Math.Pow(Math.Abs(i - nextOtherCharPos), type);
            }


            compareChar = compareChar ^ 1;
        }


        return (long)cost;
    }

    private static int nextOtherChar(string str, int startIndex, char otherChar)
    {
        return str.IndexOf(otherChar, startIndex);
    }
}
