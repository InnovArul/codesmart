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
#include <iostream>
#include <algorithm>
using namespace std;


int main() {
    /* Enter your code here. Read input from STDIN. Print output to STDOUT */
    vector<int> heap;
    int N; scanf("%d", &N);

    for(int i = 0; i < N; i++) {
        int choice; scanf("%d", &choice);
        switch(choice) {
            case 1:
                    int element; scanf("%d", &element);
                    break;
            case 2:
                    int element; scanf("%d", &element);
                    break;
            case 3:
                    printf("%d\n", heap[0]);
                    break;
        }
    }

    return 0;
}
