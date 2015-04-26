#include <iostream>
#include <string.h>
#include<stdio.h>
using namespace std;

int main()
{
	char* string = new char[10000];
	string[9999] = '\0';

	fgets(string, strlen(string), stdin);

	int charNumber = 0;

	for (int i = 0; i < strlen(string); i++)
	{
		if (string[i] == '\n')
		{
			printf("\n");
			break;
		}

		if (string[i] == ' ')
		{
			printf(" ");
			continue;
		}

		int currentNumber = string[i] - 0x30;
		charNumber = (charNumber * 10) + currentNumber;

		if (charNumber >= 97)
		{
			if (charNumber > 122) {
				charNumber -= 100;
			}

			printf("%c", charNumber);
			charNumber = 0;
		}
	}


	int temp; cin >> temp;

	delete[] string;
	return 0;
}