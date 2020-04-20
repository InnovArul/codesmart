// https://www.codechef.com/LRNDSA02/problems/CHFQUEUE
#include<bits/stdc++.h>
#include<vector>
#include<stack>
using namespace std;

#define f(i, I, N) for(int i=I; i<N; i++)
#define frev(i, N, I) for(int i=N; i>=I; i--)
#define fll(i, I, N) for(llint i=I; i<N; i++)
typedef long long llint;

int main()
{
    int chefs, levels; 
    cin >> chefs >> levels;

    // read all levels
    vector<llint> all_levels(chefs);
    f(i, 0, chefs) cin >> all_levels[i];

    stack<pair<llint, llint>> buffer;

    // total fearfulness
    llint fearfulness = 1;
    llint mod = 1e9 + 7;

    frev(i, chefs-1, 0) {
        llint current_cheflevel = all_levels[i];
        
        while(!buffer.empty() && (buffer.top().first >= current_cheflevel)) 
            buffer.pop();
        
        if(!buffer.empty()) {
            fearfulness = ((fearfulness % mod) * ((buffer.top().second - i + 1) % mod)) % mod;
        }
        
        buffer.push(pair<llint, llint>(current_cheflevel, i));
    }

    cout << fearfulness << endl;
    return 0;
}