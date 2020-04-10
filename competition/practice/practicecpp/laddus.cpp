// https://www.codechef.com/LRNDSA01/problems/LADDU
#include<iostream>
#include <assert.h> 
using namespace std;

int main()
{
    int T; cin >> T;

    for (int i = 0; i<T; i++) {
        int activities;
        string origin;  cin >> activities >> origin;

        // determine redeem limit
        int redeem_limit = 200;
        if (origin == "NON_INDIAN") redeem_limit = 400;

        int total = 0;
        for (int j=0; j<activities; j++) {
            string act_description; cin >> act_description;

            //  handle cases
            if(act_description == "CONTEST_WON") {
                int rank; cin >> rank;
                int rank_bonus = 20 - rank;
                if(rank_bonus < 0) rank_bonus = 0;

                total += 300 + rank_bonus;
            }
            else if(act_description == "TOP_CONTRIBUTOR") total += 300;
            else if(act_description == "CONTEST_HOSTED") total += 50;
            else if(act_description == "BUG_FOUND") {
                int severity; cin >> severity;
                total += severity;
            }
            // if no case matches, abort. something wrong!
            else assert(false);
        }

        // calculate redeem months
        cout << total / redeem_limit << endl;
    }

    return 0;
}