#include<iostream>
#include<vector>
using namespace std;

int main()
{
	vector<int> arr(5, 2);
	for (auto i : arr) {
		cout << i << endl;
	}
	return 0;
}