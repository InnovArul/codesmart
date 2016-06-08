#include <stdio.h>
#include <string.h> //strlen
#include <cmath>
#include <algorithm>    // std::min_element, std::max_element
#include <map>
#include <vector>
#include <iterator>  // std::begin, std::end
using namespace std;

map<char, int> getCharInstanceMap(char*& string, const size_t& len) {
	map<char, int> charInstanceMap;

	//go through all the characters and get char instance map
	for (int index = 0; index < len; ++index) {
		map<char, int>::iterator it = charInstanceMap.find(string[index]);

		if(it == charInstanceMap.end()) {
			charInstanceMap.insert(pair<char, int>(string[index], 1));
		} else {
			charInstanceMap[string[index]] = it->second + 1;
		}
	}

	return charInstanceMap;
}

vector<int> getValuesFromMap(
		std::map<char, int>& charInstanceMap)
{
	vector<int> values;
	for (map<char, int>::iterator it = charInstanceMap.begin(); it != charInstanceMap.end(); ++it) {
		values.push_back(it->second);
	}
	return values;
}

int main()
{
	//read number of tests
	int T;
	scanf("%d", &T);

	for (int test = 0; test < T; ++test) {
		//read string
		char* string = new char[10010];
		scanf("%s", string);

		//read K
		int K; scanf("%d", &K);

		//create map of chars with number of instances
		map<char, int> charInstanceMap = getCharInstanceMap(string, strlen(string));
		vector<int> values = getValuesFromMap(charInstanceMap);
		vector<int>::iterator minIt = std::min_element(values.begin(), values.end());
		int minElement = *minIt;

		int charsToBeRemoved = 0;
		for (vector<int>::iterator it = values.begin(); it != values.end(); ++it) {
			int kDiff = abs(*it - minElement);
			if(kDiff > K) charsToBeRemoved += (kDiff - K);
		}

		printf("%d\n", charsToBeRemoved);

		delete[] string;
	}

	return 0;
}
