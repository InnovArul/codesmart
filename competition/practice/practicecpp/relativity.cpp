/*******************************************************************************
 * Copyright (c) 2016 Arulkumar (arul.csecit@ymail.com).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Arulkumar (arul.csecit@ymail.com)
 *     https://www.codechef.com/JULY21C/problems/RELATIVE
 *******************************************************************************/
#include <cmath>
#include <cstdio>
#include <vector>
#include <stdio.h>
#include <iostream>
#include <algorithm>
using namespace std;


int main() {
    long int T, c, g; 
    cin >> T;
    for (int i = 0; i < T; i++) {
        cin >> g >> c;
        cout << int(pow(c, 2) / (2 * g)) << endl;
    }
}