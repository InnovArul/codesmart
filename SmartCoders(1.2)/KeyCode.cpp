#include <iostream>
#include <string.h>
using namespace std;

int main()
{
	char* keypad[] = { " ", " ", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz" };
	int tests;

	scanf("%d", &tests);

	for (int i = 0; i < tests; i++)
	{
		char* string = new char[100000];
		scanf("%s", string);

		for (int index = 0; index < strlen(string); index++)
		{
			char currentChar = string[index];
			int count = 1;

			while (currentChar == string[index + 1])
			{
				index++;
				count++;
			}

			printf("%c", keypad[currentChar - 0x30][(count - 1) % strlen(keypad[currentChar - 0x30])]);
		}

		delete[] string;
		printf("\n");
	}

	return 0;
}