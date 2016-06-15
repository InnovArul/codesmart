/*******************************************************************************
 * Copyright (c) 2016 Arulkumar
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Arulkumar (arul.csecit@ymail.com)
 *******************************************************************************/

#include <stdio.h>
#include <vector>
#include <math.h>
#include <iostream>
using namespace std;

/**
 * insert into min heap
 */
void insertIntoMinHeap(vector<int>& heap, int number)
{
	heap.push_back(number);
	int correctposition = heap.size() - 1;

	while(correctposition > 1 && heap[correctposition / 2] > number) {
		heap[correctposition] = heap[correctposition / 2];
		correctposition = correctposition / 2;
	}

	heap[correctposition] = number;
}

/**
 * deletemin from min heap
 */
int DeleteMinFromMinHeap(vector<int>& heap)
{
	//swap min element with last element
	if(heap.size() - 1 == 0) return 0;

	swap(heap[heap.size() - 1], heap[1]);
	int minElement = heap[heap.size() - 1];
	heap.pop_back();

	// heapify process to stabilize the heap
	int focusElement = heap[1];
	int currentposition = 1;
	int totalsize = heap.size() - 1;
	while(2 * currentposition <= totalsize) {
		int child1index = 2 * currentposition;
		int child2index = 2 * currentposition + 1;
		int nextcurrentposition = child1index;

		//if child2 is valid
		if(child2index <= totalsize) {
			if(heap[child1index] < heap[child2index]) {
				nextcurrentposition = child1index;
			} else {
				nextcurrentposition = child2index;
			}
		}

		if(focusElement > heap[nextcurrentposition]) {
			heap[currentposition] = heap[nextcurrentposition];
			currentposition = nextcurrentposition;
		}
		else
			break;
	}

	heap[currentposition] = focusElement;
	return minElement;
}


int getMinElement(vector<int> minheap) {
	if(minheap.size() == 1) return 0;
	return minheap[1];
}

/**
 * insert into max heap
 */
void insertIntoMaxHeap(vector<int>& heap, int number)
{
	heap.push_back(number);
	int correctposition = heap.size() - 1;

	while(correctposition > 1 && heap[correctposition / 2] < number) {
		heap[correctposition] = heap[correctposition / 2];
		correctposition = correctposition / 2;
	}

	heap[correctposition] = number;
}

/**
 * deletemax from max heap
 */
int DeleteMaxFromMaxHeap(vector<int>& heap)
{
	//swap min element with last element
	if(heap.size() - 1 == 0) return 0;

	swap(heap[heap.size() - 1], heap[1]);
	int maxElement = heap[heap.size() - 1];
	heap.pop_back();

	// heapify process to stabilize the heap
	int focusElement = heap[1];
	int currentposition = 1;
	int totalsize = heap.size() - 1;
	while(2 * currentposition <= totalsize) {
		int child1index = 2 * currentposition;
		int child2index = 2 * currentposition + 1;
		int nextcurrentposition = child1index;

		//if child2 is valid
		if(child2index <= totalsize) {
			if(heap[child1index] > heap[child2index]) {
				nextcurrentposition = child1index;
			} else {
				nextcurrentposition = child2index;
			}
		}

		if(focusElement < heap[nextcurrentposition]) {
			heap[currentposition] = heap[nextcurrentposition];
			currentposition = nextcurrentposition;
		}
		else
			break;
	}

	heap[currentposition] = focusElement;
	return maxElement;
}

int getMaxElement(vector<int> maxheap) {
	if(maxheap.size() == 1) return 0;
	return maxheap[1];
}

int main()
{
	int N; scanf("%d", &N);
	FILE* fp = fopen("output.txt", "w");
	vector<int> lessNumMaxheap, greaterNumMinheap;
	//dummy insertion
	lessNumMaxheap.push_back(0);
	greaterNumMinheap.push_back(0);

	for (int index = 0; index < N; ++index) {
		int number; scanf("%d", &number);

		//insert into max heap first
		insertIntoMaxHeap(lessNumMaxheap, number);

		//insert element into one of the heaps
		if(lessNumMaxheap.size() - greaterNumMinheap.size() > 1) {
			int maxElement = DeleteMaxFromMaxHeap(lessNumMaxheap);
			insertIntoMinHeap(greaterNumMinheap, maxElement);
		}

		//if the max of maxheap is greater than min of min heap, then swap those elements
		//reason: maxheap is used to store all the elements which are less than are equal to median
		//minheap is used to store all the elements which are greater than or equal to median
		//if they get mixed up, everything goes wrong
		if(lessNumMaxheap.size()>1 && greaterNumMinheap.size() > 1 &&
				(getMaxElement(lessNumMaxheap) > getMinElement(greaterNumMinheap))) {
			int minElement = DeleteMaxFromMaxHeap(lessNumMaxheap);
			int maxElement = DeleteMinFromMinHeap(greaterNumMinheap);
			insertIntoMaxHeap(lessNumMaxheap, maxElement);
			insertIntoMinHeap(greaterNumMinheap, minElement);
		}

		float median = 0;

		//find out the median
		if(lessNumMaxheap.size() == greaterNumMinheap.size()) {
			median = (getMaxElement(lessNumMaxheap) + getMinElement(greaterNumMinheap)) / 2.0;
		}

		//if the count is more in one of the heaps, the median is from whichever heap has higher numbers
		if(lessNumMaxheap.size() > greaterNumMinheap.size()) {
			median = getMaxElement(lessNumMaxheap);
		}
		if(lessNumMaxheap.size() < greaterNumMinheap.size()) {
			median = getMinElement(greaterNumMinheap);
		}

		//printf("%0.1f\n", median);
		fprintf(fp, "%0.1f\n", median);
	}

	fclose(fp);
	return 0;
}
