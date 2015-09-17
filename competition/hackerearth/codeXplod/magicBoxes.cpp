#include<iostream>
#include<stdio.h>

using namespace std;

typedef struct elem
{
	int data;
	struct elem* next;
} Element;

int main()
{
	int T;

	scanf("%d", &T);

	for (int test = 0; test < T; ++test) {
		int N;
		scanf("%d", &N);

		Element* head = NULL;
		Element* tail = NULL;

		for (int index = 0; index < N; ++index) {
			int currentNumber;
			scanf("%d", &currentNumber);

			Element* newnode = new Element();
			newnode->data = currentNumber;
			newnode->next = NULL;

			if(tail == NULL) tail = newnode;
			else{
				tail->next = newnode;
				tail = newnode;
			}

			if(head ==NULL) head = tail;
		}

		int magicNumber;
		scanf("%d", &magicNumber);

		Element* temp1 = head;
		Element* temp2= head->next;
		while(temp1 != NULL && temp2 != NULL)
		{
			int sum = temp1->data + temp2->data;

			if(sum % magicNumber == 0)
			{
				int newnumber = sum / magicNumber;
				temp1->data = newnumber;
				Element* junk = temp2;
				temp1->next = temp2->next;
				delete junk;

				temp2 = temp1->next;
			}
			else
			{
				temp1 = temp1->next;
				temp2 = temp2->next;
			}
		}

		Element* temp = head;
		while(temp != NULL)
		{
			printf("%d ", temp->data);
			Element* prev = temp;
			temp = temp->next;
			delete prev;
		}

		printf("\n");
	}
}
