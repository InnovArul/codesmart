// https://www.codechef.com/LRNDSA02/problems/ZCO12002
#include<bits/stdc++.h>
#include<vector>
#include<limits>
#define llint long long
using namespace std;

int main()
{
    int numslots, numonward, numreturn;
    cin >> numslots >> numonward >> numreturn;

    vector<pair<llint, llint>> contest_slots;
    vector<llint> onwardtimes, returntimes;

    // get inputs
    for(int  i=0; i<numslots; i++) {
        llint start, end; cin >> start >> end;
        contest_slots.push_back(pair<llint, llint>(start, end));
    }

    for(int  i=0; i<numonward; i++) {
        llint starttime; cin >> starttime;
        onwardtimes.push_back(-starttime);
    }

    for(int  i=0; i<numreturn; i++) {
        llint endtime; cin >> endtime;
        returntimes.push_back(endtime);
    }

    // sort onward and return times
    sort(onwardtimes.begin(), onwardtimes.end());
    sort(returntimes.begin(), returntimes.end());

    llint mintimespent = numeric_limits<llint>::max();

    for(int i=0; i<numslots; i++) {
        auto current_slot = contest_slots[i];
        llint start = current_slot.first;
        llint end = current_slot.second;

        // cout << "st " << start << " end " << end << endl;

        // corner cases
        // if the least possible onward time is greater than start of slot, continue
        if(-onwardtimes[onwardtimes.size()-1] > start) continue;
        if(returntimes[returntimes.size()-1] < end) continue;

        llint onwardtime = onwardtimes[lower_bound(onwardtimes.begin(), onwardtimes.end(), -start) - onwardtimes.begin()];
        llint returntime = returntimes[lower_bound(returntimes.begin(), returntimes.end(), end) - returntimes.begin()];
        // cout << "onward " << onwardtime << " ret " << returntime << endl;

        mintimespent = min(mintimespent, returntime + onwardtime + 1);
    }

    cout << mintimespent << endl;
}