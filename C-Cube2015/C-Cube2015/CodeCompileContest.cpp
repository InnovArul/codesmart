#include <iostream>
using namespace std;

int main()
{
	int bytes[]  = { 0, 51,145, 212, 262, 363, 472, 583, 682, 790, 891, 978};
	int differences[11];

	for(int index = 1; index < 12; index++) {
		differences[index-1] = bytes[index] - bytes[index-1];
	}

	for(int index = 10; index >= 0; index--) {
		cout<<(char)differences[index];
	}

	cout << endl;

	//int i; cin >> i;
	return 0;

}