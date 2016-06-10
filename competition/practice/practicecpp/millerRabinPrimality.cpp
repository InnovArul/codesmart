#include <stdio.h>
#include <iostream>
#include <stdlib.h>

using namespace std;

//returns a^d mod n
int power(int A, int D, int N) {
	int result = 1;
	A = A % N;

	while(D > 0) {
		// if d is odd, multiply result with a
		if(D & 1) result = (result * A) % N;

		// D should be even now
		D >>= 1;
		A = (A * A) % N;
	}

	return result;
}

bool millerTest(int D, int R, int N) {
	//choose A in [2, N-2]
	int A = 2 + rand() % (N-4);

	//compute A^D mod N
	int X_i = power(A, D, N);
	if(X_i == 1 || X_i == N-1) return true;

	//do the following for R-1 times
	for (int rIndex = 0; rIndex < R; ++rIndex) {
		X_i = (X_i * X_i) % N;

		if(X_i == 1) return false;
		if(X_i == N - 1) return true;
	}

	return false;
}

bool isPrime_RabinMiller(int N) {

	/*
	 * 1. write N-1 = 2^R . D (note down R and D, as it will be needed in further steps.
	 * 2. do the following K times
	 * 		i.  choose a number A in range [2, N-2]
	 * 		ii. compute X_0 = A^D mod N
	 * 		    	if X_0 = +-1, then N can be a prime number
	 * 		iii.do the following for R-1 times
	 * 				X_i = X_(i-1)^2 mod N
	 * 				if X_i = 1, then N is composite
	 * 				if X_i = N-1, then N is probable prime
	 * 		iv. if after R-1 iterations of above loop, if X_i's are not found to be 1 or N-1,
	 * 		    then N is composite
	 */

	// handle base cases
	if(N <= 1)   return false;
	if(N == 2)   return true;
	if(N % 2 == 0) return true;

	bool isPrime = false;

	//choose K for doing miller test K times
	int K = rand() % 10 + 4; // k is [4, 9]

	// find R, D
	// Find R such that N = 2^R * D + 1 for some R >= 1
	int D = N - 1;
	int R = 0;
	while(R % 2 == 0)
	{
		R++;
		D /= 2;
	}

	for (int index = 0; index < K; ++index) {
		isPrime = millerTest(D, R, N);
		if(!isPrime) break;
	}

	return isPrime;
}

int main()
{
	int T; scanf("%d", &T);

	for (int test = 0; test < T; ++test) {
		int N; scanf("%d", &N);

		if(isPrime_RabinMiller(N))
			printf("prime\n");
		else
			printf("composite\n");
	}

	return 0;

}
