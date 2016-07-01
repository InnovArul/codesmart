#include <stdio.h>
#include <stack>
#include <string.h>

using namespace std;

char* readString() {
	const int LENGTH = 1000;
	char* string = new char[LENGTH + 1];
	char ch;

	int strLength = 0;
	while((ch = getchar()) != EOF && strLength < LENGTH) {
		if(ch == '\n') break;
		string[strLength] = ch;
		strLength++;
	}
	string[strLength] = '\0';

	return string;

}

char isBalancer(const char mystacktop) {
	if(mystacktop == '{') return '}';
	else if(mystacktop == '(') return ')';
	else if(mystacktop == '[') return ']';
	else return '\0';
}

bool isOpener(char currentChar) {
	if((currentChar == '{') || (currentChar == '(') || (currentChar == '[')) {
		return true;
	}

	return false;
}

bool isCloser(char currentChar) {
	if((currentChar == '}') || (currentChar == ')') || (currentChar == ']')) {
		return true;
	}

	return false;
}

int main()
{
	int N; scanf("%d%*c", &N);

	for (int index = 0; index < N; ++index) {
		char* string = readString();
		int strLength = strlen(string);

		stack<char> mystack;

		int strIndex = 0;

		while(strIndex < strLength) {
			char currentChar = string[strIndex];
			if(isOpener(currentChar)) {
				mystack.push(currentChar);
			}
			else {
				if((mystack.size() == 0) || (isBalancer(mystack.top()) != currentChar)) {
					break;
				}
				mystack.pop();
			}

			strIndex++;
		}

		if(strIndex == strLength && mystack.size() == 0) printf("YES\n");
	    else printf("NO\n");

		delete[] string;
	}

	return 0;
}
