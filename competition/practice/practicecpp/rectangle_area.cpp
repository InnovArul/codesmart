// https://www.codechef.com/LRNDSA02/problems/ZCO15004
#include<bits/stdc++.h>
#include<vector>
#include<stack>
#include<limits>
using namespace std;

typedef int llint;
#define f(i, I, N) for(int i=I; i<N; i++)
#define frev(i, N, I) for(int i=N; i>=I; i--)
#define fll(i, I, N) for(llint i=I; i<N; i++)

int main()
{
    int N; cin >> N;

    vector<pair<llint, llint>> X(N);
    for(int i=0; i<N; i++) {
        cin >> X[i].first >> X[i].second;
    }

    // sort the coordinates
    sort(X.begin(), X.end());

    vector<llint> right_boundary(N);
    vector<llint> left_boundary(N);

    stack<llint> buffer;

    for(int i=0; i<N; i++) {
        llint current_Y = X[i].second;
        while(!buffer.empty() && X[buffer.top()].second >= current_Y) buffer.pop();

        // determine left boundary
        if(buffer.empty()) left_boundary[i] = 0;
        else left_boundary[i] = X[buffer.top()].first;

        buffer.push(i);
    }

    buffer = stack<llint>();

    for(int i=N-1; i>=0; i--) {
        llint current_Y = X[i].second;
        while(!buffer.empty() && X[buffer.top()].second >= current_Y) buffer.pop();

        // determine right boundary
        if(buffer.empty()) right_boundary[i] = 100000;
        else right_boundary[i] = X[buffer.top()].first;

        buffer.push(i);
    }

    // check the area between left and right boundaries
    llint maxarea = numeric_limits<llint>::min();

    for(int i=0; i<N; i++) {
        maxarea = max(maxarea, (right_boundary[i] - left_boundary[i]) * X[i].second);
    }

    maxarea = max(maxarea, ((llint)100000 - X[N-1].first) * 500);
    maxarea = max(maxarea, X[0].first * 500);

    // check the area between two points
    for(int i=1; i<N; i++) {
        maxarea = max(maxarea, (X[i].first - X[i-1].first) * 500);
    }

    cout << maxarea << endl;

    return 0;
}