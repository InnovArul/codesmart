// https://www.codechef.com/LRNDSA01/problems/CARVANS
#include<bits/stdc++.h>
#include <limits>
using namespace std;

int main()
{
    // use fast IO
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);

    int tests;
    cin >> tests;

    for (int i=0; i<tests; i++)
    {
        int cars; cin >> cars;
        int temp; cin >> temp;

        int lastspeed = temp;
        int actualspeedcount = 1;

        for (int j = 1; j<cars; j++) {
            cin >> temp;

            // if the front-going car is faster than the current car, 
            // current car can go in actual speed
            if(temp < lastspeed) {
                lastspeed = temp;
                actualspeedcount++;
            }
        }

        cout << actualspeedcount << endl;
    }

    return 0;
}