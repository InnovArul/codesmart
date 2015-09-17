#include<iostream>
#include<stdio.h>
using namespace std;

int main()
{
	int T;
	scanf("%d", &T);

	for (int test = 0; test < T; ++test) {
		int N;
		scanf("%d", &N);

		if(N%2) N--;

		// find 2^(N/2) % 1000000007
		int count = 1;

		int twopowers = N/2;

		while(twopowers > 0)
		{
			int shift = twopowers;
			if(twopowers > 31)
			{
				shift = 31;
			}
			twopowers -= 31;
			count = (count * ((1<<shift) % 1000000007)) % 1000000007;
		}

		printf("%d\n", count);
	}
	return 0;
}
