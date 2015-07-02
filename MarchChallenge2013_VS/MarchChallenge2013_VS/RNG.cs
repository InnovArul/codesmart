using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;


class RNG
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
        const long MOD = 104857601;

        long K = Scanner.nextLong();
        long N = Scanner.nextLong();

        long[] A = new long[K + 1];
        long[] C = new long[K];

        for (int i = 0; i < K; i++)
        {
            A[i] = Scanner.nextLong() % MOD;
        }

        long Anow = K;
        long previous = 0;
        for (int i = 0; i < K; i++)
        {
            C[i] = Scanner.nextLong() % MOD;

            A[K] = (A[K] + (A[K - 1 - i] * C[i])) % MOD;
            long temp = A[K - 1 - i];
            A[K - 1 - i] = previous;
            previous = temp;
        }

        A[K - 1] = A[K]; A[K] = 0;
        Anow++;

        for (long i = Anow; i < N % MOD; i++)
        {
            previous = 0;

            for (int j = 0; j < K; j++)
            {
                A[K] = (A[K] + (A[K - 1 - j] * C[j])) % MOD;
                long temp = A[K - 1 - j];
                A[K - 1 - j] = previous;
                previous = temp;
            }

            A[K - 1] = A[K]; A[K] = 0;
        }

        Console.WriteLine(A[K - 1]);
        //Console.ReadLine();
    }
}