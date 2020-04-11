// https://www.codechef.com/LRNDSA02/problems/COMPILER
#include<bits/stdc++.h>
#include<stack>
#include<assert.h>
using namespace std;

int main()
{
    int T; cin >> T;
    for(int i=0; i<T; i++)
    {
        string str; cin >> str;
        stack<char> brackets;
        int prefix_length = 0;
        
        for(int j=0; j<str.length(); j++) {
            char current_char = str[j];

            // push < into stack
            if(current_char == '<') {
                brackets.push(current_char);
            }
            // pop < if > found
            else if(current_char == '>') {
                if(brackets.size() != 0) {
                    brackets.pop();
                } 
                // if the corresponding < not found, break the loop
                else break;
                
                if(brackets.size() == 0){
                    prefix_length = j + 1;
                }   
            }
            else
            {
                assert(false);
            }
        }

        cout << prefix_length << endl;
    }
    return 0;
}