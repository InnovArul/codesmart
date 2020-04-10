// https://www.codechef.com/LRNDSA01/problems/MULTHREE
#include<bits/stdc++.h>
using namespace std;

int main()
{
    int T; cin >> T;

    for (int i=0; i<T; i++) {
        long long int k, d0, d1;
        cin >> k >> d0 >> d1;

        long long current_sum = d0 + d1;
        int last_digit = current_sum % 10;

        for(int j=2; j<k; j++) {
            // perform the unrolling addition until we reach 6
            if(last_digit == 0) break;
            else if(last_digit == 6) {
                // first add 6
                current_sum += 6; j = j+1;

                // perform op for handling remaining numbers
                long long remaining_digits = k - j;
                long long total_batches_2486 = remaining_digits / 4;

                current_sum += (total_batches_2486 * 20);

                // handle the remaining digits
                int within_batch_remaining = remaining_digits % 4;
                if(within_batch_remaining == 1) current_sum += 2;
                else if(within_batch_remaining == 2) current_sum += 2 + 4;
                else if(within_batch_remaining == 3) current_sum += 2 + 4 + 8;

                break;
            }
            else{
                current_sum += last_digit;
                last_digit = current_sum % 10;
            }
        }

        // cout << "sum " << current_sum << endl;
        if(current_sum % 3 == 0) cout << "YES" << endl;
        else  cout << "NO" << endl;
    }
    return 0;
}
