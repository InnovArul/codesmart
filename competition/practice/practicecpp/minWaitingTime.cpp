#include <stdio.h>
#include <iostream>
#include <vector>
#include <limits>

using namespace std;

class job
{
public:
	int entryTime;
	int serviceTime;
	job(int entry, int service) {
		entryTime = entry;
		serviceTime = service;
	}

	int getWaitingTime(int finishTime) {
		return finishTime - entryTime;
	}

	bool operator<(job other) {
		return serviceTime < other.serviceTime;
	}

	bool operator<=(job other) {
		return serviceTime <= other.serviceTime;
	}

	bool operator>(job other) {
		return serviceTime > other.serviceTime;
	}

	bool operator>=(job other) {
		return serviceTime >= other.serviceTime;
	}

	bool operator==(job other) {
		return serviceTime == other.serviceTime && entryTime == other.entryTime;
	}

	bool operator!=(job other) {
		return !(serviceTime == other.serviceTime && entryTime == other.entryTime);
	}
};

int getEntryTime(job temp) {
	return temp.entryTime;
}

int getServiceTime(job temp) {
	return temp.serviceTime;
}

void insertIntoheap(vector<job>& heap, job newjob, int (*getMeasure)(job))
{
	heap.push_back(newjob);

	int positionToInsert = heap.size() - 1;

	while(positionToInsert > 1 && getMeasure(heap[positionToInsert/2]) > getMeasure(newjob)) {
		heap[positionToInsert] = heap[positionToInsert/2];
		positionToInsert = positionToInsert/2;
	}

	heap[positionToInsert] = newjob;
}

job deleteMinJobFromHeap(vector<job>& heap, int (*getMeasure)(job)) {
	job minjob = heap[1];

	//swap min element with last element
	swap(heap[1], heap[heap.size() - 1]);
	heap.pop_back();

	int totalLength = heap.size() - 1;
	int currPosition = 1;

	job jobToBeHeapified = heap[1];
	while(2*currPosition <= totalLength) {
		//get the minimum job between children
		job childToReplace = heap[2*currPosition];
		int index = 2*currPosition;

		int secondChildPosition = (2*currPosition + 1);
		if(secondChildPosition <= totalLength && getMeasure(heap[secondChildPosition]) < getMeasure(childToReplace)) {
			childToReplace = heap[secondChildPosition];
			index = secondChildPosition;
		}

		if(getMeasure(childToReplace) < getMeasure(jobToBeHeapified)) {
			heap[currPosition] = childToReplace;
			currPosition = index;
		} else break;
	}

	heap[currPosition] = jobToBeHeapified;

	return minjob;
}

job getMinElement(vector<job> heap) {
	if(heap.size() <= 1) {
		return job(0,0);
	}

	return heap[1];
}

int main()
{
	//dummy insert
	job NULLJOB(0,0);
	vector<job> minjobheap; minjobheap.push_back(NULLJOB);
	vector<job> pendingjobheap; pendingjobheap.push_back(NULLJOB);
	int N; scanf("%d", &N);

	//for all the jon entry, insert them into heap
	for (int index = 0; index < N; ++index) {
		int entryTime, serviceTime;
		scanf("%d", &entryTime); scanf("%d", &serviceTime);
		job newjob(entryTime, serviceTime);
		insertIntoheap(pendingjobheap, newjob, getEntryTime);
	}

	long long totalWaitingTime = 0;
	int currentTime = 0;
	while(pendingjobheap.size() > 1 || minjobheap.size() > 1) {
		//remove all the jobs from pendingjobheap and put into minjob heap
		job tempjob = NULLJOB;
		while((tempjob = getMinElement(pendingjobheap)) != NULLJOB) {
			if(getEntryTime(tempjob) <= currentTime) {
				job currentJob = deleteMinJobFromHeap(pendingjobheap, getEntryTime);
				insertIntoheap(minjobheap, currentJob, getServiceTime);
			} else break;
		}

		//select a job from minjob queue and process
		job minjob = getMinElement(minjobheap);
		if(minjob != NULLJOB) {
			minjob = deleteMinJobFromHeap(minjobheap, getServiceTime);
			currentTime += getServiceTime(minjob);
			totalWaitingTime += minjob.getWaitingTime(currentTime);
		} else {
			//if there is no job in minjob queue, make the current time to minjob in pending job queue
			job tempjob = getMinElement(pendingjobheap);
			if(tempjob != NULLJOB) {
				currentTime = getEntryTime(tempjob);
			}
		}
	}

	long long avgWaitingTime = totalWaitingTime / N;
	printf("%lld\n", avgWaitingTime);

	return 0;
}
