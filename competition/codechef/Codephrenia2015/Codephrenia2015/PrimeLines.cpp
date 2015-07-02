#include <stdio.h>
#include <stdlib.h>
#include <math.h>

using namespace std;

class IOReadWrite
{
public:
	static int nextInt()
	{
		int number = 0;

		scanf("%d", &number);

		return number;
	}

	static void println(int number)
	{
		printf("%d\n", number);
	}

	static void println(long long number)
	{
		printf("%lld\n", number);
	}
};

bool isPrime(int num) {

	bool isprime = true;
	if (num == 0 || num == 1) {
		isprime = false;
	}
	else if (num == 2 || num == 3) {
		isprime = true;
	}
	else
	{
		if (num % 2 == 0 || num % 3 == 0)
		{
			isprime = false;
		}
		else
		{
			for (int i = 2; i <= sqrt((double)num); i++)
			{
				if (num % i == 0) {
					isprime = false;
					break;
				}
			}
		}

	}

	return isprime;
}

int main()
{
	int tests = 0;
	scanf("%d", &tests); 

	for (int i = 0; i < tests; i++)
	{
		int N = 0;
		scanf("%d", &N);

		int start = (N * (N - 1) / 2) + 1;

		long long sum = 0;

		if (start == 2)
		{
			sum = 5;
		}
		else
		{
			int initialPrime = 0;
			for (int j = start; j < start + N; j++)
			{
				if (isPrime(j))
				{
					initialPrime = j;
					sum += initialPrime;
					break;
				}
			}

			int highBound = start + N;
			while (initialPrime < highBound)
			{
				if ((initialPrime + 2)  < highBound && isPrime(initialPrime + 2)) {
					sum += initialPrime + 2;
				}

				if ((initialPrime + 4)  < highBound && isPrime(initialPrime + 4)) {
					sum += initialPrime + 4;
				}

				initialPrime += 4;
			}

		}

		IOReadWrite::println(sum);

	}
	return 0;
}

