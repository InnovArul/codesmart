#include <stdio.h>
#include <iostream>
#include <string.h>
using namespace std;

void getPalindromeString(char** string, int& stringLength) {
	char characters[] = "abcdefghijklmnopqrstuvwxyz";
	int allCharsLength = strlen(characters);
	int halfPalindromeLength = (stringLength / 2);
	halfPalindromeLength += (stringLength % 2);

	for (int index = 0; index < halfPalindromeLength; ++index) {
		(*string)[index] = characters[index % allCharsLength];
	}

	int startIndex = halfPalindromeLength;
	if(stringLength % 2) startIndex--;

	//reverse the substring
	for (int srcIndex = startIndex - 1, counter = 0; srcIndex >= 0; --srcIndex, counter++) {
		(*string)[halfPalindromeLength + counter] = (*string)[srcIndex];
	}

	(*string)[stringLength] = '\0';
}

int main()
{
	int T;
	scanf("%d", &T);

	for (int test = 0; test < T; ++test) {
		int N; scanf("%d", &N);

		if(N == 1)
			printf("a\n");
		else if(N==2)
			printf("ab\n");
		else
		{
			//determine length of the palindrome
			int remainder = N % 3;
			if(remainder == 0 || remainder == 1) {
				int stringLength = 2 * (N / 3) + remainder;
				char* string = new char[stringLength + 10];
				getPalindromeString(&string, stringLength);
				printf("%s\n", string);
				delete[] string;
			}
			else
				printf("-1\n");
		}
	}

	return 0;
}
