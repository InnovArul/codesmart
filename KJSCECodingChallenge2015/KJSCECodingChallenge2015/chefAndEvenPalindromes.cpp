#include <stdio.h>
#include <string.h>

int main()
{
	int tests = 0;
	scanf("%d", &tests);
	char* str = new char[12354];

	for (int test = 0; test < tests; test++)
	{
		int N = 0; scanf("%d", &N);

		scanf("%s", str);
		int charcount[26];
		memset(charcount, 0, 26 * sizeof(int));
		
		for (int index = 0; index < N; index++)
		{
			int character = str[index] - 0x61;
			charcount[character]++;
		}

		for (int index = 0; index < 26; index++)
		{
			if (charcount[index] % 2)
			{
				printf("%c\n", index + 0x61);
				break;
			}
		}
	}

	delete[] str;

	return 0;
}