// https://www.codechef.com/LRNDSA01/problems/FCTRL
#include<bits/stdc++.h>
using namespace std;

int main()
{
    int T; cin >> T;

    for (int i=0; i<T; i++) {
        int N; cin >> N;

        // number of leading zeros depends on the number of 5s
        long long int numberof5s = 0;
        long long int current_denominator = 5;
        long long int current_result = 0;
        do {
            current_result = (N/current_denominator);

            // update denominator
            numberof5s += current_result;
            current_denominator *= 5;
        } while(current_result > 0);

        cout << numberof5s << endl;
    }

    return 0;
}