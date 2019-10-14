#include<iostream>
#include<string>
#include <algorithm>
#include <iterator>
#include <map>
#include <vector>
using namespace std;

class character
{
    char c;
    int index;

public:
    character(char c, int index){
       this->c = c;
       this->index = index;
    }

    bool is_out_of_order(char start)
    {
        if(start == c){
            return index%2 != 0;
        }
        else{
            return index%2 != 1;
        }
    }
};


int deduce_cost(int index0, int index1, int type){
    if(type == 0) return 1;
    else return abs(index0 - index1);
}


int calc_cost(map<char, vector<int>> outoforder_chars, int type)
{
    int total_loop = min(outoforder_chars['B'].size(), outoforder_chars['G'].size());
    long long total_cost = 0;
    for (int i = 0; i < total_loop; ++i) {
        int currindex_B = outoforder_chars['B'][i];
        int currindex_G = outoforder_chars['G'][i];
        total_cost += deduce_cost(currindex_B, currindex_G, type);
    }
    return total_cost;
}

int main()
{
    int T;
    cin >> T;

    for (int i = 0; i < T; ++i) {
        int type;
        cin >> type;

        // get the initial string
        string str;
        cin >> str;

        map<char, int> char_counter;
        char_counter['B'] = 0;
        char_counter['G'] = 0;

        map<char, vector<int>> outoforder_Bfirst;
        map<char, vector<int>> outoforder_Gfirst;

        // create the vector with out of order indices
        for (int j = 0; j < str.length(); ++j) {
            char currchar = str[j];
            char_counter[currchar]++;

            character current(currchar, j);

            if(current.is_out_of_order('B')) {
                outoforder_Bfirst[currchar].push_back(j);
            }

            if(current.is_out_of_order('G')) {
                outoforder_Gfirst[currchar].push_back(j);
            }
        }

        long long cost;
        // after creating the indices, calculate cost
        int relative_count = char_counter['B'] - char_counter['G'];
        if(abs(relative_count) > 1) {
            cost = -1;
        }
        // determine the start character based on the count
        else if(relative_count == 1){
            cost = calc_cost(outoforder_Bfirst, type);
        } else if(relative_count == -1) {
            cost = calc_cost(outoforder_Gfirst, type);
        }
        // if the counts are same, decide the cost based on lowest
        else{
            int cost_Bfirst = calc_cost(outoforder_Bfirst, type);
            int cost_Gfirst = calc_cost(outoforder_Gfirst, type);

            cost = (cost_Bfirst > cost_Gfirst) ?  cost_Gfirst : cost_Bfirst;
        }

        cout << cost << endl;
    }

    return 0;
}