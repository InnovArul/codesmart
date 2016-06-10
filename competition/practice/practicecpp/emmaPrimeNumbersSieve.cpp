/*******************************************************************************
 * Copyright (c) 2016 Arulkumar (arul.csecit@ymail.com).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Arulkumar (arul.csecit@ymail.com)
 *     https://www.hackerearth.com/problem/algorithm/emma-and-the-prime-sum/
 *******************************************************************************/

#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <math.h>

using namespace std;

// Sieve of Eratosthenes
bool* createSieve(int N) {
	bool* isPrimeResult = new bool[N+1];

	// initialize all numbers as prime
	for (int j = 0; j <= N; ++j) {
		isPrimeResult[j] = true;
	}

	//base condition
	isPrimeResult[0] = isPrimeResult[1] = false;

	//for each number in  [2, square-root(N)]
	for (int i = 2; i <= sqrt(N); ++i) {

		// if the number is still marked as prime,
		if(isPrimeResult[i] == true) {

			// mark the multiples of number as composite
			for (int j = 2; j <= N; ++j) {
				if(i*j > N) break;
				isPrimeResult[i*j] = false;
			}
		}
	}
	return isPrimeResult;
}

int main()
{
	bool* isPrimeResult = createSieve(100000);
	int T; scanf("%d", &T);  // !!! VRY IMPORTANT !!!

	for (int test = 0; test < T; ++test) {
		int X; scanf("%d", &X);
		int Y; scanf("%d", &Y);
		long sum = 0;

		for (int number = X; number <= Y; ++number) {
			if(isPrimeResult[number])
				sum += number;
		}

		printf("%ld\n", sum);
	}

	delete[] isPrimeResult;
	return 0;

}
