#include<stdio.h>
#include<string.h>
#include<iostream>
#include<map>
#include<list>
#include <cmath>
using namespace std;

class IO
{
public:
	/**
	 * read an integer
	 * @return
	 */
	static void readInt(int* x)
	{
		scanf("%d", x);
	}

	/**
	 * read an integer
	 * @return
	 */
	static void readString(char** str, int strLength)
	{
		char next;
		int count = 0;
		char* rootstr = *str;
		while((next = getchar()) != EOF && count < strLength)
		{
			if(next == '\n') continue;
			rootstr[count++] = next;
		}

		rootstr[count] = '\0';
	}
};

bool checkIndexValidness(list<int> l1, std::list<int> l2, int d) {

	bool isValid = true;

	for (std::list<int>::iterator it1=l1.begin(); it1 != l1.end(); ++it1) {
		int sourceIndex = *it1;
		bool isSwapPossible = false;
		for (std::list<int>::iterator it2=l2.begin(); it2 != l2.end(); ++it2) {
			int clientIndex = *it2;
			if((int)abs(sourceIndex - clientIndex) % d == 0) {

				isSwapPossible = true;
				break;
			}
		}

		if(!isSwapPossible) {
			isValid = false;
			break;
		}
	}

	return isValid;
}

int main()
{
	int T, N, D;
	IO::readInt(&T);

	for (int test = 0; test < T; ++test) {
		IO::readInt(&N); IO::readInt(&D);
		char *kingStr = new char[N];
		char *chefStr = new char[N];
		map<char, list<int> > kingStrMap;
		map<char, list<int> > chefStrMap;
		std::map<char, list<int> >::iterator it;

		IO::readString(&kingStr, N);
		//printf("king: %s\n", kingStr);

		//create dictionary with all the characters and indices
		for (int index = 0; index < N; ++index) {
			it = kingStrMap.find(kingStr[index]);

			//if the key not found, insert new instance
			if(it == kingStrMap.end())
			{
				list<int> l; l.push_back(index);
				kingStrMap.insert(std::pair<char, list<int> >(kingStr[index], l));
			}
			else
			{
				list<int> currList = it->second;
				currList.push_back(index);
				currList.sort();
			}
		}
		delete[] kingStr;

		IO::readString(&chefStr, N);
		//printf("chef: %s\n", chefStr);
		//create dictionary with all the characters and indices
		for (int index = 0; index < N; ++index) {

			it = chefStrMap.find(chefStr[index]);

			//if the key not found, insert new instance
			if(it == chefStrMap.end())
			{
				list<int> l1; l1.push_back(index);
				chefStrMap.insert(std::pair<char, list<int> >(chefStr[index], l1));
			}
			else
			{
				list<int> currList = it->second;
				currList.push_back(index);
				currList.sort();
			}
		}
		delete[] chefStr;

		bool isSwapPossible = true;

		// check the equivalence of characters
		for (std::map<char, list<int> >::iterator it= kingStrMap.begin(); it!=kingStrMap.end(); ++it)
		{
			char currChar = it->first;
			list<int> l = it->second;

			std::map<char, list<int> >::iterator chefIt = chefStrMap.find(currChar);
			if(chefIt == chefStrMap.end())
			{
				isSwapPossible = false;
				break;
			}
			else
			{
				list<int> l1 = chefIt->second;
				if(l.size() != l1.size()){
					isSwapPossible = false;
					break;
				}
			}
		}

		if(!isSwapPossible){
			printf("No\n");
			continue;
		}

		// check the equivalence of characters
		for (std::map<char, list<int> >::iterator it= chefStrMap.begin(); it!=chefStrMap.end(); ++it)
		{
			char currChar = it->first;
			list<int> l = it->second;

			std::map<char, list<int> >::iterator kingIt = kingStrMap.find(currChar);
			if(kingIt == kingStrMap.end())
			{
				isSwapPossible = false;
				break;
			}
			else
			{
				list<int> l1 = kingIt->second;
				if(l.size() != l1.size()){
					isSwapPossible = false;
					break;
				}
			}
		}

		if(!isSwapPossible){
			printf("No\n");
			continue;
		}

		//if the counts of characters are equivalent between king string and chef string, the validate the swaps
		for (std::map<char, list<int> >::iterator it= kingStrMap.begin(); it!=kingStrMap.end(); ++it)
		{
			char currKingChar = it->first;
			list<int> l1 = it->second;

			std::map<char, list<int> >::iterator chefIt = chefStrMap.find(currKingChar);
			list<int> l2 = chefIt->second;

			if(!checkIndexValidness(l1, l2, D))
			{
				isSwapPossible = false; break;
			}
		}

		if(!isSwapPossible){
			printf("No\n");
			continue;
		}

		printf("Yes\n");
	}

	return 0;
}
