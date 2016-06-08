#include <iostream>
#include <stdio.h>
#include <string.h>

using namespace std;

void updateFenTree(int fenTreeIndex, int* fenTree, const int value, const int N) {
	//update fenwick tree
	while(fenTreeIndex > 0 && fenTreeIndex <= N)
	{
		fenTree[fenTreeIndex] += value;
		fenTreeIndex += (fenTreeIndex & -fenTreeIndex);
	}
}

bool isRoundNumber(long value)
{
	char valstring[255];
	sprintf(valstring, "%ld", value);
	int strLength = (int)strlen(valstring);

	//check if the number is round number (including checking of negative numbers)
	if(valstring[0] != valstring[strLength - 1])
		return false;

	return true;
}

int getSum(int* fenTree, int fenTreeIndex, const int N) {
	int sum = 0;

	//update fenwick tree
	while(fenTreeIndex > 0 && fenTreeIndex <= N)
	{
		sum += fenTree[fenTreeIndex];
		fenTreeIndex -= (fenTreeIndex & -fenTreeIndex);
	}

	return sum;
}

template<class T>
void printArray(T* array, int N, bool isLong, char* string) {
	printf("%s : ", string);
	for (int index = 0; index < N; ++index) {
		if(isLong) printf("%ld  ", array[index]);
		else printf("%d  ", array[index]);
	}
	printf("\n");
}

int main()
{
	int N, Q;
	scanf("%d", &N); scanf("%d", &Q);

	long* A = new long[N];
	int* fenTree = new int[N + 1];

	//init fenwick tree
	for (int index = 0; index < N+1; ++index) {
		fenTree[index] = 0;
	}

	//read numbers
	for (int index = 0; index < N; ++index) {
		scanf("%ld", &A[index]);
		int fenTreeIndex = index + 1;

		if(isRoundNumber(A[index]))
		{
			updateFenTree(fenTreeIndex, fenTree, 1, N);
		}
	}

	//print fenwick tree and actual array
	//printArray<long>(A, N, true, "actual-array");
	//printArray<int>(fenTree, N+1, false, "fenwick-tree");

	//read queries and answer
	for (int query = 0; query < Q; ++query) {
		int qType; scanf("%d", &qType);

		if(qType == 1) {
			int l, r;
			scanf("%d", &l); scanf("%d", &r);
			int lower = getSum(fenTree, l-1, N);
			int higher = getSum(fenTree, r, N);
			printf("%d\n", higher - lower);
		}
		else
		{
			int i;
			long K;
			scanf("%d", &i); scanf("%ld", &K);

			//print fenwick tree and actual array
			//printArray<long>(A, N, true, "before-actual-array");
			//printArray<int>(fenTree, N+1, false, "before-fenwick-tree");

			//update for removal of round number
			if(isRoundNumber(A[i-1]) && !isRoundNumber(K))
				updateFenTree(i, fenTree, -1, N);

			//update for new round number
			if(!isRoundNumber(A[i-1]) && isRoundNumber(K))
				updateFenTree(i, fenTree, 1, N);

			//update actual array
			A[i - 1] = K;

			//print fenwick tree and actual array
			//printArray<long>(A, N, true, "after-actual-array");
			//printArray<int>(fenTree, N+1, false, "after-fenwick-tree");
		}
	}

	delete[] A;
	return 0;
}
