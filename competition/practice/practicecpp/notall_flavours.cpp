// https://www.codechef.com/LRNDSA02/problems/NOTALLFL
#include<bits/stdc++.h>
#include<map>
#define llint long long
using namespace std;

int main() {
    int T; cin >> T;

    for (llint i=0; i<T; i++) {
        llint N, K; cin >> N >> K;

        vector<llint> cake_flavors;
        for(llint j=0; j<N; j++) {
            llint temp; cin >> temp;
            cake_flavors.push_back(temp);
        }

        map<llint, llint> flavor_count;

        // init all flavor count to 0
        for(llint j=0; j<K; j++) flavor_count[j] = 0;

        llint maxsubseq = 0;
        llint backpointer = 0;
        llint total_diff_flavors = 0;
        for(llint j=0; j<N; j++) {
            llint current_flavor = cake_flavors[j];
            flavor_count[current_flavor]++;

            if(flavor_count[current_flavor] == 1) total_diff_flavors++;

            // now if the total different flavor reaches K
            // we have to note down subsequence length and
            // move backpointer to appropriate position
            if(total_diff_flavors == K) {
                // move backpointer
                // cout << "K";
                while(total_diff_flavors == K) {
                    flavor_count[cake_flavors[backpointer]]--;
                    if(flavor_count[cake_flavors[backpointer]] == 0) {
                        total_diff_flavors--;
                    }
                    backpointer++;
                }
            }

            maxsubseq = max(maxsubseq, j - backpointer + 1);
        }

        cout << maxsubseq << endl;
    }
    return 0;
}