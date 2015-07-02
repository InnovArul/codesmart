#include<stdio.h>
#include<string.h>
#include <math.h>

/* Utility function to get max of 2 integers */
int max(int a, int b)
{
	return (a > b) ? a : b;
}

int getLongestSubsequence(char* X, char* Y, int m, int n)
{
	int* L[255];

	for (int i = 0; i < 255; i++)
	{
		L[i] = new int[255];
	}

	int i, j;

	/* Following steps build L[m+1][n+1] in bottom up fashion. Note
	that L[i][j] contains length of LCS of X[0..i-1] and Y[0..j-1] */
	for (i = 0; i <= m; i++)
	{
		for (j = 0; j <= n; j++)
		{
			if (i == 0 || j == 0)
				L[i][j] = 0;

			else if (X[i - 1] == Y[j - 1])
				L[i][j] = L[i - 1][j - 1] + 1;

			else
				L[i][j] = max(L[i - 1][j], L[i][j - 1]);
		}
	}

	/* L[m][n] contains length of LCS for X[0..n-1] and Y[0..m-1] */
	return L[m][n];
}


int main() {
	char *alicestr = new char[1000];
	char *bobstr = new char[1000];
	scanf_s("%s", alicestr, 1000);
	scanf_s("%s", bobstr, 1000);

	const int bobstrlen = strlen(bobstr) ;
	const int alicestrlen = strlen(alicestr);

	int** matrix = new int*[bobstrlen + 1];

	for (int i = 0; i < bobstrlen + 1; i++)
	{
		matrix[i] = new int[alicestrlen + 1];
	}

	int length = getLongestSubsequence(bobstr, alicestr, bobstrlen, alicestrlen);
	printf("%d", length);

	// scanf_s("%d", &length);
}