//  https://www.codechef.com/LRNDSA01/problems/ZCO14003

#include<bits/stdc++.h>
#include<vector>
using namespace std;

int main()
{
    int N;
    cin >> N;

    vector<long long int> budgets;

    for(int i=0; i<N; i++)
    {
        int temp;
        cin >> temp;
        budgets.push_back(temp);
    }

    // sort the budget list
    sort(budgets.begin(), budgets.end());

    long long int maxbudget = 0;
    int lastbudget = 0;

    // find max budget / profit
    for(int i=0; i < N; i++) {
        if(lastbudget != budgets[i]) {
            maxbudget = max(maxbudget, (N-i)*budgets[i]);
            lastbudget = budgets[i];
        }
    }

    cout << maxbudget << endl;
    
}