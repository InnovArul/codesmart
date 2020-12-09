// https://www.codechef.com/LRNDSA01/problems/CONFLIP
#include<iostream>
using namespace std;

int main()
{
    int T; cin >> T;

    for(int i=0; i<T; i++) {
        int games; cin >> games;

        // process each hame
        for(int j=0; j<games; j++) {
            int init_face, num_coins, query;
            cin >> init_face >> num_coins >> query;

            int num_faces = num_coins / 2;
            if(num_coins % 2 == 1 && init_face != query) {
                // if odd number of games
                num_faces++;
            }

            cout << num_faces << endl;
        }
    }
    return 0;
}