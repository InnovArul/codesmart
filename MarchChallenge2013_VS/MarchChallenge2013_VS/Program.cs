using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

class Program
{

    /// Similar to Java.util.scanner class
    ///
    static class Scanner
    {
        ///
        /// variable to hold tokens
        ///
        internal static Queue<string> tokens = new Queue<string>();

        /// API to return next token
        ///
        ///
        internal static string next()
        {
            if (tokens.Count <= 0)
            {
                // read the whole line and split into tokens
                string[] toks = Console.ReadLine().Split();
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
            return Console.ReadLine();
        }

        ///

        /// read and return next empty line from the console
        ///
        ///
        internal static string nextNonEmptyLine()
        {
            string str = Console.ReadLine();

            while (str.Trim().Equals(""))
            {
                str = Console.ReadLine();
            }
            return str;
        }
    }
    static void Main(string[] args)
    {
        int NumTests = Scanner.nextInt();

        for (int i = 0; i < NumTests; i++)
        {
            int sine = Scanner.nextInt();
            int cos = Scanner.nextInt();
            int K = Scanner.nextInt();

            long totalPts = getSinePoints(sine - K + 1) + getCosPoints(cos);

            Console.WriteLine(totalPts);
        }

        Console.ReadKey();

    }

    private static long getCosPoints(int cos)
    {
        if (cos <= 0)
        {
            return 0;
        }

        return (long)Math.Pow(2, cos);
    }

    private static long getCosPoints(int cos, int sine, int K)
    {

        long points = 0;
        if (sine >= K)
        {
            points = (long)Math.Ceiling(getSinePoints(sine) / Math.Pow(2, cos));
        }
        return points;
    }

    private static long getSinePoints(int sine)
    {
        if (sine <= 0)
        {
            return 0;
        }

        return (long)Math.Pow(2, sine) + 1;
    }
}
