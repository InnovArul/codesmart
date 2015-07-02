#include <stdio.h>

int main() {
	int X, Y;
	scanf("%d", &X);
	scanf("%d", &Y);

	long long result = 1;

	int min = (X > Y) ? Y : X;

	for (int i = 0; i < min; i++) {
		result *= ((X+Y) - i);
	}

	for (int i = 1; i <= min; i++) {
		result /= i;
	}

	printf("%lld\n", result);

	main();
}