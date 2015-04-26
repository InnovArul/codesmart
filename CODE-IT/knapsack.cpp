#include<stdio.h>
#include<math.h>
#include <set>

using namespace std;

/* Function maximum definition */
/* x, y and z are parameters */
int maximum(int x, int y, int z) {
	int max = x; /* assume x is the largest */

	if (y > max) { /* if y is larger than max, assign y to max */
		max = y;
	} /* end if */

	if (z > max) { /* if z is larger than max, assign z to max */
		max = z;
	} /* end if */

	return max; /* max is the largest value */
} /* end function maximum */


int getMaxWeight(int* values, int index, int maxIndex, int K) {

	if (index > maxIndex) return 0;

	if (K <= 0) return 0;

	if (values[index] > K) return 0;

	int val1 = 0;
	if (values[index] <= K)
		val1 = values[index] + getMaxWeight(values, index, maxIndex, K - values[index]);

	int val2 = 0;
	if (values[index] <= K)
		val2 = values[index] + getMaxWeight(values, index + 1, maxIndex, K - values[index]);

	int val3 = getMaxWeight(values, index + 1, maxIndex, K);

	return maximum(val1, val2, val3);
}

int main() {

	int tests = 0;

	scanf("%d", &tests);

	for (int test = 0; test < tests; test++)
	{
		int numValues = 0, K = 0;
		scanf("%d", &numValues);
		scanf("%d", &K);

		int* values;
		set<int> vals;

		for (int idx = 0; idx < numValues; idx++)
		{
			int num = 0;
			scanf("%d", &num);
			vals.insert(num);
		}

		int index = 0;
		values = new int[vals.size()];
		for (set<int>::iterator it = vals.begin(); it != vals.end(); it++)
		{
			values[index++] = *it;
		}

		printf("%d\n", getMaxWeight(values, 0, index - 1, K));

	}

	scanf("%d", &tests);
	return 0;
}