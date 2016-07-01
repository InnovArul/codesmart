/*******************************************************************************
 * Copyright (c) 2016 Arulkumar (arul.csecit@ymail.com).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Arulkumar (arul.csecit@ymail.com)
 *     https://www.hackerrank.com/challenges/qheap1
 *******************************************************************************/
#include <cmath>
#include <cstdio>
#include <vector>
#include <stdio.h>
#include <iostream>
#include <algorithm>
using namespace std;


int main() {
    /* Enter your code here. Read input from STDIN. Print output to STDOUT */
    vector<int> heap; heap.push_back(0); // insert dummpy element to use 1-indexed array
    int N; scanf("%d", &N);
    FILE *fp = fopen("output.txt", "w");

    for(int i = 0; i < N; i++) {
        int choice; scanf("%d", &choice);
        int element, correctposition, position, index;
        switch(choice) {
            case 1:
            		//read the element to be inserted
                    scanf("%d", &element);
                    heap.push_back(element); //dummy insertion

                    //heapify
                    correctposition = heap.size() - 1;
                    while(correctposition > 1 && heap[correctposition / 2] > element) {
                    	heap[correctposition] = heap[correctposition / 2];
                    	correctposition /= 2;
                    }

                    heap[correctposition] = element;

                    break;
            case 2:
            		//read the element to be removed
                    scanf("%d", &element);
                    position = 1;
                    for(int i = 1; i <= heap.size() - 1; i++) {
                    	if(heap[i] == element) {
                    		position = i;
                    		break;
                    	}
                    }

                    heap[position] = heap[heap.size() - 1];
                    heap.pop_back();

                    while((2 * position) <= heap.size() - 1) {
                    	index = 2 * position;
                    	if((2*position + 1) <= heap.size() - 1 && heap[2 * position + 1] < heap[2*position]) {
                    		index = 2 * position + 1;
                    	}

                    	if(heap[index] < heap[position]) {
							swap(heap[index], heap[position]);
							position = index;
                    	} else break;
                    }

                    break;
            case 3:
                    fprintf(fp, "%d\n", heap[1]);
                    printf("%d\n", heap[1]);

                    break;
        }
    }

    fclose(fp);
    return 0;
}
