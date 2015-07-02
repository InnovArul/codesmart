#include<stdio.h>
#include<math.h>
#include <set>
#include <iostream>
#include <vector>

using namespace std;

int min(int a, int b) {
	return a < b ? a : b;
}

int getMinStates(int state, vector<int> states, vector<int> empty) {
	if (state >= states.size()) {
		return 1;
	}

	if (std::find(empty.begin(), empty.end(), state) != empty.end()) return 0;

	int numOfFullStates = 0;

	while (state < states.size() && states.at(state) == 0) {
		numOfFullStates++;
		empty.push_back(state);
		state++;
	}

	std::vector<int> copy1(empty);
	int viaNextState = 0;
	if (std::find(copy1.begin(), copy1.end(), state) == copy1.end()){
		copy1.push_back(state);
		viaNextState = getMinStates(state + 1, states, copy1);
	}
	
	std::vector<int> copy2(empty);
	int viaShortcut = 0;
	if (state <= states.size()-1 && std::find(copy1.begin(), copy1.end(), states.at(state)) == copy1.end()){
		copy2.push_back(state);
		copy2.push_back(states.at(state));
		viaShortcut = getMinStates(states.at(state), states, copy2);
	}

	return numOfFullStates + min(1 + viaNextState, viaShortcut);

}

int main() {

	int numstates = 0;

	scanf("%d", &numstates);

	vector<int> states;

	for (int st = 0; st < numstates; st++)
	{
		int state = 0;
		cin >> state;
		states.push_back(state);
	}

	vector<int> empty;
	int minStates = getMinStates(0, states, empty);
	printf("%d\n", minStates);
	scanf("%d", &numstates);

	return 0;
}