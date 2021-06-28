/************************************************

CS6310 Artificial Neural Networks
Assignment 1

Vector Dot product

Author: Arulkumar S (CS15S023)

*************************************************/

#include <stdio.h>
#include <cuda.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdarg.h>     /* va_list, va_start, va_arg, va_end */
#include <stdlib.h>     /* srand, rand */
#include <time.h>
#define NUMBER_OF_THREADS  512

FILE* fp;

/**
*  The instructions which will be running in NVIDIA graphics card processor cores.
*
*/
__global__ void multiply(int* number1, int* number2, int* products, int length)
{
	int index = (blockIdx.x * NUMBER_OF_THREADS) + threadIdx.x;

	// multiply the components of the vector
	if(index < length)
		products[index] = number1[index] * number2[index];

}

/*
 A wrapper to copy the memory contents from Host to GPU device

 parameters:

 hostMemory[in]			 = contains source address in Host
 deviceMemoryAddress[in] = contains destination address in Device
 dataLength[in]			 = length of the array to be copied

*/
template<typename T>
void copyToDevice(T* hostMemory, T** deviceMemoryAddress, int dataLength)
{
	int totalSize = dataLength * sizeof(T);
	cudaMalloc((void**) deviceMemoryAddress, totalSize);
	cudaMemcpy(*deviceMemoryAddress, hostMemory, totalSize, cudaMemcpyHostToDevice);
}

/*
 A wrapper to copy the memory contents from GPU Device to Host

 parameters:

 hostMemory[in]			 = contains Destination address in Host
 deviceMemoryAddress[in] = contains Source address in Device
 dataLength[in]			 = length of the array to be copied

*/

template<typename T>
void copyFromDevice(T* hostMemory, T* deviceMemoryAddress, int dataLength)
{
	int totalSize = dataLength * sizeof(T);
	
	// copy the results from device to host
	cudaMemcpy(hostMemory, deviceMemoryAddress, totalSize, cudaMemcpyDeviceToHost);;
}

/*
 A wrapper to free the memory allocate in GPU device.
 This API accepts variable number of arguments. Number of arguments should be given as first parameter.

 parameters:

 n_args[in] = number of arguments passed

*/
void freeDeviceMemory(int n_args, ...)
{
	// initialize variable argument list
	va_list vl;
	va_start(vl, n_args);
	void* pointer;

	for(int index= 0; index < n_args; index++)
	{
		pointer = va_arg(vl, void*);
		cudaFree(pointer);
	}

	//end the variable argument list
	va_end(vl);
}

/*
	randomly fill the vector to the given length
*/
void fillVector(char* name, int* vector, int length)
{
	fprintf(fp, "\n\n%s (%d x 1)\n\n", name, length);

	for(int index = 0; index < length; index++)
	{
		vector[index] = rand() % 10;
		fprintf(fp, "%d  ", vector[index]);
	}

	fprintf(fp, "\n\n");
}

/*
*  Vector dot product using NVIDIA Graphics card + CUDA C programming  
*
*  Main program entry
*/
int main()
{
	clock_t start, end;
	fp = fopen("Task1_data.txt", "w+");

	//based on the input format , change the vector preparation
	printf("Enter dimension (number of components) of vector space (e.g., 1000) : ");
	int veclength;
	scanf("%d", &veclength);

	int* vector1;
	vector1 = (int*) malloc(veclength * sizeof(int));
	fillVector("vector1", vector1, veclength);  //fill random numbers for vector1

	int* vector2;
	vector2 = (int*) malloc(veclength * sizeof(int));
	fillVector("vector2", vector2, veclength);  //fill random numbers for vector2

	int* products;
	products = (int*) malloc(veclength * sizeof(int));  //buffer to hold inner products

	int finalDotProduct = 0;

	int* vector1_d;
	int* vector2_d;
	int* products_d;

	// copy the input contents from Host to device
	copyToDevice<int>(vector1, &vector1_d, veclength);
	copyToDevice<int>(vector2, &vector2_d, veclength);
	copyToDevice<int>(products, &products_d, veclength);

	start = clock();
	// call function with 1 block, number of threads equal to total number of vector components
	multiply<<<(veclength / NUMBER_OF_THREADS) + 1, NUMBER_OF_THREADS, veclength * sizeof(int)>>>(vector1_d, vector2_d, products_d, veclength);
	end = clock() - start;

	fprintf(fp,"GPU time taken = %f\n\n", (double) end / (double) CLOCKS_PER_SEC);

	// copy the results from device to host
	copyFromDevice<int>(products, products_d, veclength);

	for(int index = 0; index < veclength; index++)
	{
		finalDotProduct += products[index];
	}


	// display the result
	printf("GPU dot product: %d\n\n", finalDotProduct);
	fprintf(fp, "GPU dot product: %d\n\n", finalDotProduct);

	//free device memory
	freeDeviceMemory(3, vector1_d, vector2_d, products_d);

	//do multiplication in PC
	finalDotProduct = 0;
	start = clock();
	for(int index = 0; index < veclength; index++)
	{
		finalDotProduct += (vector1[index] * vector2[index]);
	}

	end = clock() - start;
	fprintf(fp, "PC time taken = %f\n\n", (double) end / (double) CLOCKS_PER_SEC);

	// display the result
	printf("Host dot product: %d\n\n", finalDotProduct);
	fprintf(fp, "Host dot product: %d\n\n", finalDotProduct);

	//free host variables
	free(vector1); free(vector2); free(products);

	printf("\nrefer to Task1_data.txt for results\n\n"); 

	fclose(fp);

	//wait for user key
	getchar(); getchar();

	exit(0);
}