/*******************************************************************************
 * Copyright (c) 2016 Arulkumar (arul.csecit@ymail.com).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Arulkumar (arul.csecit@ymail.com)
 *******************************************************************************/
#include <stdio.h>

using namespace std;
const long MODULO = 10e9 + 7;

class input {
private:
	/**
	 * a generic template method for reading input
	 * @param content
	 * @param formatString
	 */
	template<typename T>
	static void readContent(T& content, char* formatString) {
		scanf(formatString, &content);
	}

public:
	/**
	 * to read integer input
	 * @param number
	 */
	static void read(int& number) {
		readContent(number, "%d");
	}

	/**
	 * to read float input
	 * @param number
	 */
	static void read(float& number) {
		readContent(number, "%f");
	}

	/**
	 * to read long input
	 * @param number
	 */
	static void read(long& number) {
		readContent(number, "%ld");
	}
};

/**
 *
 * @param number1
 * @param number2
 */
long addWithModulo(const long& number1, const long& number2) {
	long addition = ((number1 % MODULO) + (number2 % MODULO)) % MODULO;
	return addition;
}

void applySequentialAddition(long* array, int N)
{
	for (int index = 1; index < N; ++index) {
		array[index] = addWithModulo(array[index-1], array[index]);
	}
}

/**
 * main function
 * @return
 */
int main() {
	int T;
	input::read(T);

	for (int test = 0; test < T; ++test) {
		//read inputs for testcase
		int N, x, M;
		input::read(N);
		input::read(x);
		input::read(M);
		long* array = new long[N];

		for (int index = 0; index < N; ++index) {
			input::read(array[index]);
		}

		for (int m = 0; m < M; ++m) {
			applySequentialAddition(array, N);
		}

		printf("%ld\n", array[x - 1]);

		delete[] array;
	}

	return 0;
}
