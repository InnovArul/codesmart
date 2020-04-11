// https://www.codechef.com/LRNDSA02/problems/STUPMACH
#include<iostream>
#include<vector>
#include<limits>
#define llint long long
using namespace std;

int main()
{
    llint T; cin >> T;

    for(llint i=0; i<T; i++) {
        llint N; cin >> N;
        vector<llint> capacity;

        // read the capacity array
        for(llint j=0; j<N; j++) {
            llint temp; cin >> temp;
            capacity.push_back(temp);
        }

        llint maxcapacity = 0;
        llint smaller = numeric_limits<llint>::max();

        for(llint j=0; j<N; j++) {
            if(capacity[j] < smaller) {
                smaller = capacity[j];
            }
            
            maxcapacity += smaller;
        }

        cout << maxcapacity << endl;
    }
    return 0;
}