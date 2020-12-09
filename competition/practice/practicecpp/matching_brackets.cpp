// https://www.codechef.com/LRNDSA02/problems/ZCO12001
#include<bits/stdc++.h>
#include<stack>
#include<limits>
using namespace std;

int main()
{
    int N; cin >> N;
    stack<pair<int, int>> brackets;

    int continuous1s = 0;
    int start_depth, max_depth, start_interior, max_interior;
    max_interior = max_depth = numeric_limits<int>::min();

    for(int i=0; i<N; i++) {
        int temp; cin >> temp;

        if(temp == 1) {
            continuous1s++;
            brackets.push(pair<int, int>(i, continuous1s));
        }
        else{
            auto current_open = brackets.top();
            brackets.pop();

            // decode and note down the depth, start point if needed
            int start_point = current_open.first;
            int continuous1s_sofar = current_open.second;
            
            //  modify the max nested depth and starting position
            if(continuous1s_sofar > max_depth) {
                max_depth = continuous1s_sofar;
                start_depth = start_point + 1;
            }

            // calculate interior length
            int interior_length = i - start_point + 1;
            if(interior_length > max_interior) {
                max_interior = interior_length;
                start_interior = start_point + 1;
            }

            continuous1s = continuous1s_sofar - 1;
        }
    }

    cout << max_depth << " " << start_depth << " " << max_interior << " " << start_interior << endl;
    return 0;
}