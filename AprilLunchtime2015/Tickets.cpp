#include<stdio.h>
#include<iostream>
#include<string.h>

using namespace std;

int main()
{
	int tests;

	scanf("%d", &tests);

	for (int i = 0; i < tests; i++)
	{
		char* string = new char[200];
		scanf("%s", string);

		char first = string[0];
		char second = string[1];
		char currentChar = first;
		bool isAlternate = true;

		for (int index = 0; index < strlen(string); index++)
		{
			if (string[index] != currentChar || first == second)
			{
				isAlternate = false;
				break;
			}

			currentChar = (currentChar == first) ? second : first;
		}

		if (isAlternate)
		{
			printf("YES\n");
		}
		else
		{
			printf("NO\n");
		}

		delete[] string;
	}
}