using System;
using System.IO;
using System.Collections.Generic;

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

                if (toks.Length > 1)
                {
                    foreach (var tok in toks)
                    {
                        tokens.Enqueue(tok);
                    }

                    // return the token at front
                    return tokens.Dequeue();
                }
                else
                {
                    return toks[0];
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

        /// to return the integer which is available next in the console
        ///
        ///
        internal static long nextLong()
        {
            long integer = 0;

            while (!long.TryParse(next(), out integer))
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
        int N = Scanner.nextInt();
        int K = Scanner.nextInt();

        int count = 0;

        for (int i = 0; i < N; i++)
        {
            if (Scanner.nextInt() % K == 0) count++;
        }

        Console.WriteLine(count);
        //Console.ReadLine();
    }
}