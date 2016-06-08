#include <stdio.h>
#include <algorithm>    // std::min
#include <cmath>
#include <limits.h>
using namespace std;

int main()
{
	//number of tests
	int T;
	scanf("%d", &T);

	for (int test = 0; test < T; ++test) {
		//number of elements
		int N;
		scanf("%d", &N);

		//scan the array elements
		int* array = new int[N];

		//calculate better maximal subsum
		int sum = 0, answer = INT_MIN, minimalElement = 0, numElements = 0;

		for (int index = 0; index < N; ++index) {
			//scan the element
			scanf("%d", &array[index]);

			//update the running sum
			sum += array[index]; numElements++;
			minimalElement = min(array[index], minimalElement);
			int actualSum = sum - minimalElement;

			//update the answer, if the answer is less than sum
			if(actualSum >= answer) {
				// if there is only onxe element available in the sequence, we
				// should not remove the element from the sum
				if(numElements == 1) minimalElement = 0;

				// delete one element (min element from the sum
				answer = actualSum;

				//reset the minimum element
				//minimalElement = 0;
			}

			//if the running sum is less than 0, reset sum to 0
			if(actualSum < 0) {
				sum = 0;
				numElements = 0;
				minimalElement = 0;
			}
		}

		delete[] array;
		printf("%d\n", answer);
	}

	return 0;
}
