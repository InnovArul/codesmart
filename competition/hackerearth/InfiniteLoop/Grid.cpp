#include<iostream>
#include<set>
#include<stdio.h>
#include<math.h>
using namespace std;

int min(int a, int b)
{
	return (a < b) ? a : b;
}

int getCountOfCubes(int rows, int columns)
{
	int adjCubes = 0;
	int numRow = 0, numCol = 0;
	int totalCubes = rows * columns;

	if (rows == 1 && columns == 1)
	{
		return 0;
	}

	if (rows >= 2)
	{
		adjCubes += 2 * ((rows > 1) + (columns > 1) + ((rows > 1) && (columns > 1)));
		totalCubes -= 2;
		
		int remainingRows = rows - 2;
		adjCubes += min(2, columns) * remainingRows * (2 + (columns >= 2) * 3);
		totalCubes -= min(2, columns) * remainingRows;
	}

	if (columns >= 2)
	{
		adjCubes += 2 * ((rows > 1) + (columns > 1) + ((rows > 1) && (columns > 1)));
		totalCubes -= 2;

		int remainingCols = columns - 2;
		adjCubes += min(2, rows) * remainingCols * (2 + (rows >= 2) * 3);
		totalCubes -= min(2, rows) * remainingCols;
	}

	adjCubes += totalCubes * 8;

	return adjCubes;
}


int main()
{
	int tests, rows, columns;

	scanf("%d", &tests);

	for (int i = 0; i < tests; i++)
	{
		scanf("%d", &rows);
		scanf("%d", &columns);

		int totalAdj = getCountOfCubes(rows, columns);
		printf("%d\n", totalAdj);
	}

	return 0;
}