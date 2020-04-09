// https://www.codechef.com/problems/DCL2015H#

#include<stdio.h>
#include<string.h>
#include<iostream>
#include<map>
#include<list>
#include <cmath>
using namespace std;

class IO
{
private:
	/**
	 * read an integer
	 * @return
	 */
    template<typename T>
	static void _read(T* x, const char* formatter)
	{
		scanf(formatter, x);
	}

public:
    static void readInt(int* x)
	{
		IO::_read(x, "%d");
	}

    static void readInt(long long* x)
	{
		IO::_read(x, "%lld");
	}

    static void readInt(unsigned long long* x)
	{
		IO::_read(x, "%llu");
	}    

	/**
	 * read an integer
	 * @return
	 */
	static void readString(char** str, int strLength)
	{
		char next;
		int count = 0;
		char* rootstr = *str;
		while((next = getchar()) != EOF && count < strLength)
		{
			if(next == '\n') continue;
			rootstr[count++] = next;
		}

		rootstr[count] = '\0';
	}
};

long long getPowerN(int number, long long N, long long modN)
{
    long long result = 1;
    while(N > 0) {
        // if N is odd
        if(N & 1) result = ((result % modN) * (number % modN)) % modN;

        // divide N by 2
        N = N >> 1;
        number = ((number % modN) * (number % modN)) % modN;
    }

    return (result+modN) % modN;
}

int getNways(long long N)
{
    long long modN = 1e9 + 7;
    return getPowerN(2, N, modN) - 1;
}

int main()
{
    int nTests;
    IO::readInt(&nTests);

    for (int i = 0; i < nTests; i++)
    {
        long long n;
        IO::readInt(&n);
        long long nways = getNways(n);
        printf("%lld\n", nways);
    }
}