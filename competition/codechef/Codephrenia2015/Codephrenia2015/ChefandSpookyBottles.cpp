#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cstdlib>
#include<vector>
#include <numeric>
#include <set>

using namespace std;

bool isSubsetSum(vector<int> divisors, int index, int sum)
{
	if (index < 0 || sum < 0)
	{
		return false;
	}

	return isSubsetSum(divisors, index - 1, sum) || (divisors[index] == sum) || isSubsetSum(divisors, index - 1, sum - divisors[index]);
}

int main()
{
	int tests = 0;
	scanf("%d", &tests);
	vector<int> divisors;

	for (int i = 0; i < tests; i++)
	{
		int N = 0;
		scanf("%d", &N);

		set<int> s;
		divisors.clear();

		for (int j = 1; j <= sqrt(N) + 1; j++)
		{
			if (N % j == 0) {
				s.insert(j);
				if (j != (N / j) && (N / j) != N) {
					s.insert(N / j);
				}
			}
		}

		divisors.assign(s.begin(), s.end());

		// check two conditions
		bool isSpooky = false;

		int sum_of_elems = std::accumulate(divisors.begin(), divisors.end(), 0);
		bool issubsetSum = isSubsetSum(divisors, divisors.size() - 1, N);
		if (sum_of_elems > N && !issubsetSum) {
			isSpooky = true;
		}

		printf("%s\n", isSpooky ? "SPOOKY" : "OK");
	}
}