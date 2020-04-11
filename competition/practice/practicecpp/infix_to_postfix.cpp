// https://www.codechef.com/LRNDSA02/problems/INPSTFIX
#include<bits/stdc++.h>
#include<stack>
#include<unordered_map>
using namespace std;

void print_stack(stack<char> stck) {
    cout << endl;
    while(!stck.empty()) {
        cout << stck.top() << " ";
        stck.pop();
    }
    cout << endl;
}

int main()
{
    int T; cin >> T;
    unordered_map<char, int> precedence = {
        {'+', 0},
        {'-', 0},
        {'*', 1},
        {'/', 1},
        {'^', 2},
    };

    for(int i=0; i<T; i++) {
        int N; cin >> N;

        // for(int j=0; j<N; j++){
        string str; cin >> str;
        stack<char> buffer;

        for(int k=0; k<str.length(); k++) {
            char current_char = str[k];
            // push the '(' and operators into stack
            if(current_char == '(')
            {
                buffer.push(current_char);
                // print_stack(buffer);
            }
            else if(current_char == '+' || 
                    current_char == '-' ||
                    current_char == '*' ||
                    current_char == '/' ||
                    current_char == '^')
            {
                // if the current top is not '(', check the precedence
                while(!buffer.empty() &&
                    buffer.top() != '(' && 
                    precedence.at(buffer.top()) >= precedence.at(current_char))
                {
                    cout << buffer.top(); buffer.pop();
                }

                buffer.push(current_char);
                // print_stack(buffer);
            }
            else if(current_char == ')') {
                // when encountered a ')', pop the stack until the '(' is found
                char popped_char;
                do {
                    popped_char = buffer.top();
                    if(popped_char!='(') cout << popped_char;
                    buffer.pop();
                    // print_stack(buffer);
                }while(popped_char != '(' && !buffer.empty());
            }
            else {
                // print the alphabets to console
                cout << current_char;
            }
        }

        // make the stack empty
        while(!buffer.empty()) {
            cout << buffer.top();
            buffer.pop();
        }

        cout << endl;
        // }
    }
    return 0;
}