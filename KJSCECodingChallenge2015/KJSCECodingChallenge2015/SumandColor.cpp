#include <stdio.h>
#include <string.h>

int getDigitAddition(int number) {
	if (number <= 9) return number;
	int addition = getDigitAddition(number % 10 + getDigitAddition(number / 10));
	return addition;
}

int main()
{
	int tests = 0;
	scanf("%d", &tests);
	char* colors[] = {
		"red",
		"blue",
		"pink",
		"white",
		"black",
		"violet",
		"cyan",
		"yellow",
		"green",
		"brown"
	};


	for (int test = 0; test < tests; test++)
	{
		int N = 0; scanf("%d", &N);
		int max = 0;

		for (int numIndex = 0; numIndex < N; numIndex++)
		{
			int number = 0, addition;
			scanf("%d", &number);

			addition = getDigitAddition(number);

			max = (max >= addition) ? max : addition;
		}

		printf("%s\n", colors[max]);

	}
	return 0;
}