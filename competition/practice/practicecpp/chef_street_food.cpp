// https://www.codechef.com/LRNDSA02/problems/STFOOD
#include<bits/stdc++.h>
#include<cmath>
using namespace std;

int main()
{
    int T; cin >> T;
    for (int i=0; i<T; i++) {
        int N; cin >> N;

        vector<int> profit;
        for(int j=0; j<N; j++) {
            int shops, people, value;
            cin >> shops >> people >> value;
            profit.push_back(int(floor(people / (shops + 1)) * value));
        }

        cout << *max_element(profit.begin(), profit.end()) << endl;
    }

    return 0;
}