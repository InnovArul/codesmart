// https://www.codechef.com/LRNDSA01/problems/LAPIN
#include<iostream>
#include<bits/stdc++.h> 
using namespace std;

int main()
{
    int nTests;
    cin >> nTests;

    for(int i = 0; i < nTests; i++)
    {
        string s;
        cin >> s;

        // get half strings
        string firsthalf = s.substr(0, s.length()/2);

        int secondhalf_start = s.length() / 2;
        if(s.length() % 2 == 1) secondhalf_start = secondhalf_start + 1;
        string secondhalf = s.substr(secondhalf_start, s.length());

        // sort the strings
        sort(firsthalf.begin(), firsthalf.end());
        sort(secondhalf.begin(), secondhalf.end());

        // cout << firsthalf << endl;
        // cout << secondhalf << endl;

        if(firsthalf != secondhalf) cout << "NO" << endl;
        else cout << "YES" << endl;        
    }

    return 0;
}