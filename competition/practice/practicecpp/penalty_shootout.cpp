// https://www.codechef.com/LRNDSA02/problems/PSHOT
#include<iostream>
#include<cmath>
#include<assert.h>
using namespace std;

int main()
{
    int T; cin >> T;
    for(int i=0; i<T; i++) {
        int N; cin >> N;
        string shootouts; cin >> shootouts;

        int A_goals = 0, B_goals = 0;

        // assert string length
        assert(N*2 == shootouts.length());
        int earliest_step = 0;

        for(int j = 0; j<shootouts.length(); j++) {
            if(j%2 == 0 && shootouts[j] == '1') A_goals++;
            else if(j%2 == 1 && shootouts[j] == '1') B_goals++;

            int A_remaining = N - (j/2) - 1;
            int B_remaining = N - (j/2) - (j%2);

            // determine the earliest step
            if(A_goals > (B_goals + B_remaining)  // A wins
                || B_goals > (A_goals + A_remaining) // B wins
                ) 
            { 
                    earliest_step = j+1; 
                    break;
            }

            earliest_step = j+1;
        }

        cout << earliest_step << endl;
    }

    return 0;

}