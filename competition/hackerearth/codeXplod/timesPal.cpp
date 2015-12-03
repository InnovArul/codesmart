#include <iostream>
#include <stdio.h>
#include <string.h>
usign namespace std;

int main()
{
	int tests;

	scanf("%d", &tests);

	char* A = new char[10000];
	char* B = new char[10000];
	for (int test = 0; test < tests; ++test) {
		scanf("%d", A);
		scanf("%d", B);


	}
	delete[] A; delete[] B;
	return 0;

}
