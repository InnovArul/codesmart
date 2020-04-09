// https://www.codechef.com/LRNDSA01/problems/FLOW007

#include<iostream>
#include <bits/stdc++.h> 

using namespace std;

int main()
{
    int nTests;
    cin >> nTests;

    for (auto i = 0; i < nTests; i++)
    {
        string s;
        cin >> s;
        
        // reverse the string
        reverse(s.begin(), s.end());
        cout << stoi(s, nullptr, 10) << endl;
    }
    
    return 0;
}