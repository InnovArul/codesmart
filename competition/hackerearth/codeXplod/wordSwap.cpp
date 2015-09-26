#include <iostream>
#include <stdio.h>
#include <string.h>
using namespace std;
#define MAX_NAME_SZ 100001

int main()
{
	int tests;

	scanf("%d", &tests);

	char dummy;
	// to overcome the \n character after scanf
	fread(&dummy, 1, 1, stdin);
	fflush(stdin);

	for (int test = 0; test < tests; ++test) {
		char* string = new char[MAX_NAME_SZ];
		char* outstring = new char[MAX_NAME_SZ];
		outstring[0] = '\0';
	    /* Get the string, with size limit. */
	    fgets (string, MAX_NAME_SZ, stdin);
	    sscanf(string, "%[^\n]", string);

		char* token = strtok(string, " ");

		while(token != NULL)
		{
			//create a temporary string
			char* tempStr = new char[MAX_NAME_SZ];

			//copy the token to temp string
			strcpy(tempStr, token);

			//append the soace
			strcat(tempStr, " ");

			// get next token
			token = strtok(NULL, " ");

			// concatenate temp string
			strcat(tempStr, outstring);

			//swap the temp string with outstring
			swap(outstring, tempStr);
			delete[] tempStr;
		}

		outstring[strlen(outstring) - 1] = '\0';
		printf("%s\n", outstring);
		delete[] string;
		delete[] outstring;

	}
	return 0;
}
