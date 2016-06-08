#include <stdio.h>

int main()
{
	//number of tests
	int T;
	scanf("%d", &T);

	for (int test = 0; test < T; ++test) {
		// number of students
		int N;
		scanf("%d", &N);

		int* finishTimes = new int[N];

		//scan the finish times
		for (int index = 0; index < N; ++index) {
			scanf("%d", &finishTimes[index]);
		}

		int numFinishingStudents = 0;

		//count the number of students who could finish the cooking
		//scan the cooking times & count
		int prevTime = 0;

		for (int index = 0; index < N; ++index) {
			int currentStudTime;
			scanf("%d", &currentStudTime);

			int availableTime = finishTimes[index] - prevTime;
			if(availableTime >= currentStudTime) numFinishingStudents++;

			prevTime = finishTimes[index];
		}

		printf("%d\n", numFinishingStudents);

		delete[] finishTimes;
	}

	return 0;
}
