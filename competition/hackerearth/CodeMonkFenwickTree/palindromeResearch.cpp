#include <stdio.h>
#include <iostream>
#include <vector>
#include <map>
using namespace std;

void readString(char** str, int strLength)
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

void updateFenTree(int fenTreeIndex, const char prevCharacter, const char updateCharacter, map<char, int>* fenTree, int N)
{
	// update fentree construct
	while(fenTreeIndex > 0 && fenTreeIndex <= N)
	{
		//delete previous character
		map<char, int>::iterator it = fenTree[fenTreeIndex].find(prevCharacter);
		if(it != fenTree[fenTreeIndex].end())
		{
			it->second--;
		}

		//update the character
		map<char, int>::iterator it1 = fenTree[fenTreeIndex].find(updateCharacter);
		if(it1 == fenTree[fenTreeIndex].end())
		{
			fenTree[fenTreeIndex].insert(pair<char, int>(updateCharacter, 1));
		}
		else
		{
			it1->second++;
		}

		fenTreeIndex += (fenTreeIndex & -fenTreeIndex);
	}

}

map<char, int>* createFenwickTree(char*& string, int& N) {
	map<char, int>* fenTree = new map<char, int>[N + 1];

	for (int index = 0; index < N; ++index) {
		int fenTreeIndex = index + 1;
		char value = string[index];

		// update fentree construct
		while(fenTreeIndex > 0 && fenTreeIndex <= N)
		{
			map<char, int>::iterator it = fenTree[fenTreeIndex].find(value);
			if(it == fenTree[fenTreeIndex].end())
			{
				fenTree[fenTreeIndex].insert(pair<char, int>(value, 1));
			}
			else
			{
				it->second++;
			}

			fenTreeIndex += (fenTreeIndex & -fenTreeIndex);
		}

	}

	return fenTree;
}

void printFenTree(std::map<char, int>*& fenTree, int N)
{
	for (int index = 1; index <= N; ++index) {
		map<char, int> element = fenTree[index];
		printf("Index = %d \n", index);
		for (map<char, int>::iterator it = fenTree[index].begin(); it != fenTree[index].end(); ++it) {
			printf(" %c --> %d, ", it->first, it->second);
		}
		printf("\n");
	}
}

void printFenElement(map<char, int> fenElement, char* string)
{
	printf("%s\n", string);
	for (map<char, int>::iterator it = fenElement.begin(); it != fenElement.end(); ++it) {
		printf(" %c --> %d, ", it->first, it->second);
	}
	printf("\n");
}

map<char, int> getCumulativeFenTree(std::map<char, int>*& fenTree, const int& index, int N)
{
	map<char, int> fenElement;
	int fenTreeIndex = index;

	while(fenTreeIndex > 0 && fenTreeIndex <= N)
	{
		for(map<char, int>::iterator it = fenTree[fenTreeIndex].begin(); it != fenTree[fenTreeIndex].end(); ++it) fenElement[it->first] += it->second;
		fenTreeIndex -= (fenTreeIndex & -fenTreeIndex);
	}

	return fenElement;
}

int main()
{
	int N; 	scanf("%d", &N);
	int Q; 	scanf("%d", &Q);

	char* string = new char[N];
	readString(&string, N);

	map<char, int>* fenTree = createFenwickTree(string, N);
	//printFenTree(fenTree, N);

	for (int query = 0; query < Q; ++query) {
		int qType; scanf("%d", &qType);
		int index; scanf("%d", &index);

		if(qType == 1)
		{
			//if query is to update fen tree, read the character
			char updateStr[3]; scanf("%s", updateStr);
			char updateChar = updateStr[0];
			char prevChar = string[index - 1];
			updateFenTree(index, prevChar, updateChar, fenTree, N);
			string[index - 1] = updateChar;
			//printFenTree(fenTree, N);
		}
		else
		{
			//if query is to check for palindrome, read next index
			int startIndex = index;
			int endIndex; scanf("%d", &endIndex);

			map<char, int> fentreeLower = getCumulativeFenTree(fenTree, startIndex - 1, N + 1);
			//printFenElement(fentreeLower, "sum until start index");
			map<char, int> fentreeHigher = getCumulativeFenTree(fenTree, endIndex, N + 1);
			//printFenElement(fentreeHigher, "sum upto end index");
			for(map<char, int>::iterator it = fentreeLower.begin(); it != fentreeLower.end(); ++it) fentreeHigher[it->first] = fentreeHigher[it->first] - it->second;
			//printFenElement(fentreeHigher, "Difference");

			int oddCount = 0;
			//check if all the counts are even (expect atmost one element)
			for(map<char, int>::iterator it = fentreeHigher.begin(); it != fentreeHigher.end(); ++it)
			{
				if(it->second % 2) oddCount++;
			}

			if(oddCount >= 2) printf("no\n");
			else printf("yes\n");

		}
	}

	delete[] fenTree;
	delete[] string;

	return 0;
}
