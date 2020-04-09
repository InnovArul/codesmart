// https://www.codechef.com/LRNDSA01/problems/TEST
#include<iostream>
using namespace std;

int main()
{
    bool is_break = false;
    while(!is_break) {
        int number;
        cin >> number;
        
        // if number is 42, break 
        // else, send the number to console
        if(number == 42) is_break = true;
        else cout << number << endl;
    }

    return 0;
}