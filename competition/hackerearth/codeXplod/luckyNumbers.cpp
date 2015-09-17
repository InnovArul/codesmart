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
		int *numbers = new int[N];

		for (int index = 0; index < N; ++index) {
			scanf("%d", &numbers[index]);
		}

		int luckyNumbers = 1;
		int max = numbers[N-1];
		for (int index = N-2; index >= 0; --index) {
			if(numbers[index] > max)
			{
				max =numbers[index];
				luckyNumbers++;
			}
		}

		printf("%d\n", luckyNumbers);

		delete[] numbers;
	}
	return 0;
}
