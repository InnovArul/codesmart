#include <iostream>
#include <stdio.h>
#include <map>
using namespace std;

int main()
{
	int T, N;
	scanf("%d", &T);

	for (int test = 0; test < T; ++test) {
		scanf("%d", &N);

		map<int, int> subarrays;
		int totalMax = 0;

		for (int index = 0; index < N; ++index) {
			int currentNumber;
			scanf("%d", &currentNumber);

			int currmaxLength = 1;
			for (map<int, int>::iterator it = subarrays.begin(); it != subarrays.end(); ++it) {
				int number = it->first;
				int count = it->second;

				if(currentNumber % number == 0)
				{
					currmaxLength = max(currmaxLength, count + 1);
				}
			}

			subarrays[currentNumber] = currmaxLength;
			totalMax = max(totalMax, currmaxLength);
		}

		printf("%d\n", totalMax);
	}
	return 0;
}
