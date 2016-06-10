/*******************************************************************************
 * Copyright (c) 2016 Arulkumar (arul.csecit@ymail.com).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Arulkumar (arul.csecit@ymail.com)
 *     https://www.codechef.com/MAY14/problems/CHEFBM
 *******************************************************************************/

#include <iostream>
#include <stdio.h>
#include <vector>
#include <limits.h>

using namespace std;

int main()
{
	int nrows, ncols, ncommands;
	scanf("%d", &nrows); 	scanf("%d", &ncols); 	scanf("%d", &ncommands);
	vector<int>* twoDarray = new vector<int>[nrows];

	//read all the array elements
	for (int rowIdx = 0; rowIdx < nrows; ++rowIdx) {
		for (int colIdx = 0; colIdx < ncols; ++colIdx) {
			twoDarray[rowIdx].push_back(colIdx + 1);
		}
	}

	//read the commands and do the manipulation
	for (int commandIdx = 0; commandIdx < ncommands; ++commandIdx) {
		int rowId, colId;
		scanf("%d", &rowId); scanf("%d", &colId);
		twoDarray[rowId-1][colId-1]++;
	}

	//print all the array elements
/*	printf("\nafter commands\n");
	for (int rowIdx = 0; rowIdx < nrows; ++rowIdx) {
		for (int colIdx = 0; colIdx < ncols; ++colIdx) {
			printf("%d  ", twoDarray[rowIdx][colIdx]);
		}
		printf("\n ");
	}*/

	//check for strange matrix criteria in all rows
	for (int rowIdx = 0; rowIdx < nrows; ++rowIdx) {
		int pathsum = 0;
		int prevValue = 0;
		for (int index = twoDarray[rowIdx].size() - 1; index >= 0; --index) {
			if(index == (twoDarray[rowIdx].size() - 1))
				prevValue = twoDarray[rowIdx][index];
			else
			{
				int currValue = twoDarray[rowIdx][index];
				int difference = prevValue - currValue;
				if(difference < 0)
				{
					pathsum = -1;
					printf("%d\n", pathsum);
					break;
				}
				else
					pathsum += difference;

				prevValue = currValue;
			}
		}

		if(pathsum == -1) continue;
		printf("%d\n", pathsum);
	}

	return 0;
}
