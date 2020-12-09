// https://www.codechef.com/problems/RRPLAYER
#include<bits/stdc++.h>
#include<vector>
using namespace std;

double get_harmonic_number(int N, map<int, double>& harmonic_memory) {
    double harmonic_number;
    // cout << " get_harmonic_number " <<  N << endl;
    if(harmonic_memory.find(N) != harmonic_memory.end()) {
        // cout << " if " <<  N << endl;
        harmonic_number = harmonic_memory[N];
    }
    else 
    {
        // cout << " else " <<  N << endl;
        harmonic_number = (1.0 / N) + get_harmonic_number(N-1, harmonic_memory);
    }

    harmonic_memory[N] = harmonic_number;
    return harmonic_number;
}

int main()
{
    int T; cin >> T;
    map<int, double> harmonic_memory;
    harmonic_memory[0] = 0.0;

    for(int i=0; i<T; i++) {
        int N; cin >> N;
        double expected_trials = N * get_harmonic_number(N, harmonic_memory);

        cout << expected_trials << endl;
    }
}