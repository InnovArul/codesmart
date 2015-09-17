#include <iostream>
#include <stdio.h>
#include <climits>
#include <string.h>
using namespace std;

#define MAX 1000001
int* minPrimes = new int[MAX];

int findMinPrimes(int N)
{

	int count = N;

	if(N == 2) return 1;
	if(N <= 1) return 0;

	if(minPrimes[N] == 0)
	{
		return 1;
	}

	for (int number = N - 1; number >= N/2; --number) {
		if(minPrimes[number] == 0)
		{
			int current = findMinPrimes(N - number);
			if(current >= 1)
				count = min(count, 1 + current);
		}
	}

	return count == N ? 0 : count;
}

int main()
{
	int T, N;
	memset(minPrimes, 0, MAX * sizeof(int));

	minPrimes[0] = 1;
	minPrimes[1] = 1;

	for (int number = 2; number < MAX; number += 1) {
		int index = 2;
		int current = (index * number);
		while(current < MAX)
		{
			minPrimes[current] = 1;
			current = (++index * number);
		}
	}

	scanf("%d", &T);

	for (int test = 0; test < T; ++test) {
		scanf("%d", &N);
		int minPrimes = findMinPrimes(N);
		printf("%d\n", minPrimes);
	}
	return 0;
}
