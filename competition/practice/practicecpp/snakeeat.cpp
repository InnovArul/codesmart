//
// Created by arul on 8/10/19.
//

#include<iostream>
#include<string>
#include <algorithm>
#include <iterator>
using namespace std;


template<typename T>
vector<T> get_inputs(int count)
{
    vector<T> buffer;
    for (int i = 0; i < count; ++i) {
        T temp;
        cin >> temp;
        buffer.push_back(temp);
    }
    return buffer;
}


template<typename T>
void print_vector(vector<T> const &input)
{
    std::copy(input.begin(), input.end(),
            ostream_iterator<T>(cout, " "));
}

int get_insertion_point(vector<int> array, double d) {
    return 0;
}

int main()
{
    // get the inputs
    int T;
    cin >> T;

    for (int i = 0; i < T; ++i) {
        int N, Q;
        cin >> N >> Q;

        //read the list of lengths
        vector<int> lengths = get_inputs<int>(N);

        //sort the list to have it ready for the problem
        sort(lengths.begin(), lengths.end());  // O(N log N)

        //handle the queries
        for (int k = 0; k < Q; ++k) {
            int current_K;
            cin >> current_K;

//            int count = get_insertion_point(lengths, (float) current_K + 0.5);
        }

    }

    return 0;
}