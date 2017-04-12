#include <stdio.h>
#include <vector>
#include <stack>
using namespace std;

int main()
{
	int N; scanf("%d", &N);

	int* array = new int[N];
	stack<int> mystack;
	long long maxArea = 0;

	for (int index = 0; index < N; ++index) {
		//printf("%d\n", index);
		scanf("%d", &array[index]);

		if(mystack.empty()) {
			//notice that we are pushing only indices
			mystack.push(index);
		}
		else {
			// if the current top indexed element is less than or equal to currently read element
			// push the current index to the stack
			if(array[mystack.top()] <= array[index]) mystack.push(index);
			else {
				// if there is an sequence inverse (greater element, lesser element), as long as the top is greater than the current element,
				// pop the stack and calculate the area
				int blocksSoFar = index;
				while(!mystack.empty() && array[mystack.top()] > array[index]) {
					//pop the current top index
					int topIndex = mystack.top();
					int currentMinHeight = array[topIndex];
					mystack.pop();

					// calculate the number of adjacent blocks with respect to the current minimum height
					int numberOfAdjBlocks = 0;

					//if the stack is empty, the number of adjacent blocks are all the blocks read so far
					if(mystack.empty()) numberOfAdjBlocks = blocksSoFar;
					// if the stack is not empty, the number of adjacent blocks are the difference between
					// already popped index and current top index of the stack
					else numberOfAdjBlocks = blocksSoFar - (mystack.top() + 1);

					//calculate the area & get the max height
					long long currentArea = currentMinHeight * numberOfAdjBlocks;
					maxArea = max(currentArea, maxArea);
				}

				mystack.push(index);
			}
		}
	}

	int blocksSoFar = N;
	// pop the stack and calculate the area
	while(!mystack.empty()) {
		//pop the current top index
		int topIndex = mystack.top();
		int currentMinHeight = array[topIndex];
		mystack.pop();

		// calculate the number of adjacent blocks with respect to the current minimum height
		int numberOfAdjBlocks = 0;

		//if the stack is empty, the number of adjacent blocks are all the blocks read so far
		if(mystack.empty()) numberOfAdjBlocks = blocksSoFar;
		// if the stack is not empty, the number of adjacent blocks are the difference between
		// already popped index and current top index of the stack
		else numberOfAdjBlocks = blocksSoFar - (mystack.top() + 1);

		long long currentArea = currentMinHeight * numberOfAdjBlocks;
		maxArea = max(currentArea, maxArea);
	}

	printf("%ld\n", maxArea);
	delete[] array;

	return 0;
}
