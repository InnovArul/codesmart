// https://www.codechef.com/problems/UWCOI20A
#include<bits/stdc++.h>
#include<vector>
using namespace std;

template<typename T>
vector<T> subvector(vector<T> const &v, int m, int n) {
   auto first = v.begin() + m;
   auto last = v.begin() + n + 1;
   vector<T> vector(first, last);
   return vector;
}

template<typename T>
void print_vector(vector<T> const &v) {
    for (size_t i = 0; i < v.size(); i++)
    {
        cout << v[i] << " ";
    }
    cout << endl;
}

int find_highest_peak(vector<int> array) {
    // print_vector(array);
    // int temp; cin >> temp;
    int len = array.size();
    int mid = len / 2;

    // corner cases
    if(len == 2) {
        if(array[0] > array[1]) return array[0];
        else return array[1];

    }

    if(len == 1) return array[0];

    int left_peak = find_highest_peak(subvector(array, 0, mid-1));
    int right_peak = find_highest_peak(subvector(array, mid+1, len-1));
    int current_peak = array[mid];

    return max(left_peak, max(current_peak, right_peak));
}

int main() {
    int T; cin >> T;
    for (int i = 0; i < T; i++)
    {   
        int N; cin >> N;
        vector<int> array(N);
        for (size_t j = 0; j < N; j++)
        {
            cin >> array[j];
        }

        cout << find_highest_peak(array) << endl;
    }
    return 0;
}