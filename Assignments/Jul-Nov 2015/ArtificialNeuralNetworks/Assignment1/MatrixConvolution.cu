/************************************************

CS6310 Artificial Neural Networks
Assignment 1

Colvolution of 2D matrices

Author: Arulkumar S (CS15S023)

*************************************************/

#include<stdio.h>
#include "cuda.h"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdarg.h>     /* va_list, va_start, va_arg, va_end */
#include <stdlib.h>     /* srand, rand */
#include <time.h>       /* time */

FILE* fp;

/*
A wrapper to allocate memory in GPU device

parameters:

deviceMemoryAddress[in] = contains destination address in Device
dataLength[in]			 = length of the array to be allocated

*/
template<typename T>
void allocateDeviceMemory(T** deviceMemoryAddress, int dataLength)
{
	int totalSize = dataLength * sizeof(T);
	cudaMalloc((void**) deviceMemoryAddress, totalSize);
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
	//allocate the memory in device
	allocateDeviceMemory<T>(deviceMemoryAddress, dataLength);

	// copy the contents from Host to device
	cudaMemcpy(*deviceMemoryAddress, hostMemory, dataLength * sizeof(T), cudaMemcpyHostToDevice);
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
An API to check if the passed index is valid according to the total rows and columns

parameters:

currentRow[in] = row number for whcih the validness to be checked
currentColumn[in] = column number for whcih the validness to be checked
totalRow[in] = total number of rows
totalColumn[in] = total number of columns

*/
__host__ __device__ bool isIndexValid(int currentRow, int currentColumn, int totalRow, int totalColumn)
{
	bool isValid = false;

	//the index should be between 0 & (totalrows - 1) (or) (totalcolumns - 1) 
	if((currentRow >= 0)  && (currentRow < totalRow) && (currentColumn >= 0)  && (currentColumn < totalColumn))
		isValid = true;

	return isValid;
}

// a macro to simplify 2D array access by rows and columns
#define arrayAccess(arrayName, row, colCount, col) arrayName[(row * colCount) + col]

/*
the device API to convolute the big matrix with the given kernel

parameters:

inputMatrix[in]   = big matrix to be convoluted
kernel[in]        = the kernel which used to convolute big matrix
kernelRow[in]     = number of rows in kernel
kernelColumn[in]  = number of columns in kernel
inputColumn[in]   = number of columns in input matrix
the number of rows will be found by blockIdm.x
outputMatrix[out] = buffer to hold the convoluted matrix contents

*/
__global__ void convolute(int* inputMatrix, int* kernel, int kernelRow, int kernelColumn, int inputColumn, int* outputMatrix)
{
	//find the index of the input matrix to which the convolution has to be found
	int currentInputRowIndex = blockIdx.x;
	int currentInputColIndex = threadIdx.x;

	// find the midpoint of the kernel
	int rowMid = kernelRow / 2;
	int colMid = kernelColumn / 2;

	//for each value of the kernel, multiply it with appropriate input matrix value
	int value = 0;
	for (int index1 = -rowMid; index1 <= rowMid; index1++)
	{

		for (int index2 = -colMid; index2 <= colMid; index2++)
		{
			//find current kernel row & column index
			int currentKernelRow = (kernelRow - rowMid - 1) - index1;
			int currentKernelCol = (kernelColumn - colMid - 1) - index2;

			// find appropriate input matrix indexes w.r.t., kernel
			int inputRow = currentInputRowIndex + index1;
			int inputCol = currentInputColIndex + index2;

			// if the index of input matrix is valid, multiply it with kernel value
			if(isIndexValid(inputRow, inputCol, blockDim.x, inputColumn))
			{
				value += (arrayAccess(inputMatrix, inputRow, inputColumn, inputCol)
					* arrayAccess(kernel, currentKernelRow, kernelColumn, currentKernelCol));

			}

		}
	}

	// assign the new value in output matrix for particular index
	arrayAccess(outputMatrix, currentInputRowIndex, blockDim.x, currentInputColIndex) = value;
}

/*
the device API to convolute the big matrix with the given kernel (the multiplication is done as like filtering)

parameters:

inputMatrix[in]   = big matrix to be convoluted
kernel[in]        = the kernel which used to convolute big matrix
kernelRow[in]     = number of rows in kernel
kernelColumn[in]  = number of columns in kernel
inputColumn[in]   = number of columns in input matrix
the number of rows will be found by blockIdm.x
outputMatrix[out] = buffer to hold the convoluted matrix contents

*/
__global__ void convoluteAsFilter(int* inputMatrix, int* kernel, int kernelRow, int kernelColumn, int inputColumn, int* outputMatrix)
{
	//find the index of the input matrix to which the convolution has to be found
	int currentInputRowIndex = blockIdx.x;
	int currentInputColIndex = threadIdx.x;

	// find the midpoint of the kernel
	int rowMid = kernelRow / 2;
	int colMid = kernelColumn / 2;

	//for each value of the kernel, multiply it with appropriate input matrix value
	int value = 0;
	for (int index1 = -rowMid; index1 <= rowMid; index1++)
	{

		for (int index2 = -colMid; index2 <= colMid; index2++)
		{
			//find current kernel row & column index
			int currentKernelRow = rowMid + index1;
			int currentKernelCol = colMid + index2;

			// find appropriate input matrix indexes w.r.t., kernel
			int inputRow = currentInputRowIndex + index1;
			int inputCol = currentInputColIndex + index2;

			// if the index of input matrix is valid, multiply it with kernel value
			if(isIndexValid(inputRow, inputCol, blockDim.x, inputColumn))
			{
				value += (arrayAccess(inputMatrix, inputRow, inputColumn, inputCol)
					* arrayAccess(kernel, currentKernelRow, kernelColumn, currentKernelCol));

			}

		}
	}

	// assign the new value in output matrix for particular index
	arrayAccess(outputMatrix, currentInputRowIndex, blockDim.x, currentInputColIndex) = value;
}


/*
the host API to convolute the big matrix with the given kernel (the multiplication is done as like filtering)

parameters:

inputMatrix[in]   = big matrix to be convoluted
inputMatRow[in]   = the row count of the big matrix
inputMatCol[in]   = the column count of the big matrix
kernel[in]        = the kernel which used to convolute big matrix
kernelRow[in]     = number of rows in kernel
kernelColumn[in]  = number of columns in kernel
outputMatrix[out] = buffer to hold the convoluted matrix contents

*/
void convoluteInHost(int* inputMatrix, int inputMatRow, int inputMatColumn, int* kernel, int kernelRow, int kernelColumn, int* outputMatrix)
{

	for(int bigMatRow = 0; bigMatRow < inputMatRow; bigMatRow++)
	{
		for(int bigMatCol = 0; bigMatCol < inputMatColumn; bigMatCol++)
		{
			//find the index of the input matrix to which the convolution has to be found
			int currentInputRowIndex = bigMatRow;
			int currentInputColIndex = bigMatCol;

			// find the midpoint of the kernel
			int rowMid = kernelRow / 2;
			int colMid = kernelColumn / 2;

			//for each value of the kernel, multiply it with appropriate input matrix value
			int value = 0;
			for (int index1 = -rowMid; index1 <= rowMid; index1++)
			{

				for (int index2 = -colMid; index2 <= colMid; index2++)
				{
					//find current kernel row & column index
					int currentKernelRow = rowMid + index1;
					int currentKernelCol = colMid + index2;

					// find appropriate input matrix indexes w.r.t., kernel
					int inputRow = currentInputRowIndex + index1;
					int inputCol = currentInputColIndex + index2;

					// if the index of input matrix is valid, multiply it with kernel value
					if(isIndexValid(inputRow, inputCol, inputMatRow, inputMatColumn))
					{
						value += (arrayAccess(inputMatrix, inputRow, inputMatColumn, inputCol)
							* arrayAccess(kernel, currentKernelRow, kernelColumn, currentKernelCol));

					}

				}
			}

			// assign the new value in output matrix for particular index
			arrayAccess(outputMatrix, currentInputRowIndex, inputMatRow, currentInputColIndex) = value;
		}
	}
}



/*
API to print the matrix
*/
void printMatrixRowMajor(char* name, int* matrix, int matrixRow, int matrixColumn)
{
	fprintf(fp, "\n%s (%d x %d)\n\n", name, matrixRow, matrixColumn);

	for(int rowIndex = 0; rowIndex < matrixRow; rowIndex++)
	{
		for(int columnIndex = 0; columnIndex < matrixColumn; columnIndex++)
		{
			fprintf(fp, "%-10d", matrix[(rowIndex * matrixColumn) + columnIndex]);
		}
		fprintf(fp, "\n");
	}

	fprintf(fp, "\n");
}

/*
fill the matrix in row major form randomly
*/
void fillMatrixRowMajor(int* matrix, int matrixRow, int matrixColumn)
{
	for(int rowIndex = 0; rowIndex < matrixRow; rowIndex++)
	{
		for(int columnIndex = 0; columnIndex < matrixColumn; columnIndex++)
		{
			matrix[(rowIndex * matrixColumn) + columnIndex] = rand() % 10;
		}
	}
}


/*
Main entry point
*/

int main()
{
	clock_t start, end;
	fp = fopen("Task3_data.txt", "w+");

	/* initialize random seed: */
	srand ((unsigned int)time(NULL));

	//input variables
	int inputRow, inputColumn;
	int kernelRow, kernelColumn;

	//get the total number of columns , rows count of matrices
	printf("\n row count of input (Big) matrix    : ");
	scanf("%d", &inputRow);
	printf("\n column count of input (Big) matrix : ");
	scanf("%d", &inputColumn);
	printf("\n row count of Filter Matrix   : ");
	scanf("%d", &kernelRow);
	printf("\n column count of Filter Matrix : ");
	scanf("%d", &kernelColumn);

	//vlaidate for count of rows & columns for the filter
	if(((kernelRow % 2) != 1) ||  ((kernelColumn % 2) != 1))
	{
		fprintf(fp, "\n\nERROR: Kernel (Filter) rows (given: %d) and columns(given: %d) count should be an odd number.\n\n", kernelRow, kernelColumn);
		printf("\n\nERROR: Kernel (Filter) rows (given: %d) and columns(given: %d) count should be an odd number.\n\n", kernelRow, kernelColumn);

		getchar();getchar();
		exit(0);

	}

	// input data
	int* inputMatrix; inputMatrix = (int*)malloc(inputRow * inputColumn * sizeof(int));
	fillMatrixRowMajor(inputMatrix, inputRow, inputColumn);

	int* kernel; kernel = (int*)malloc(kernelRow * kernelColumn * sizeof(int));
	fillMatrixRowMajor(kernel, kernelRow, kernelColumn);

	// print the input and kernel matrix
	printMatrixRowMajor("input matrix", inputMatrix, inputRow, inputColumn);
	printMatrixRowMajor("kernel matrix", kernel, kernelRow, kernelColumn);

	int* outputMatrix;

	// declarations to hold kernel allocated memory
	int* inputMatrix_d;
	int* kernel_d;
	int* outputMatrix_d;

	// copy the input data from host to GPU device
	copyToDevice<int>(inputMatrix, &inputMatrix_d, inputRow * inputColumn);
	copyToDevice<int>(kernel, &kernel_d, kernelRow * kernelColumn);
	allocateDeviceMemory<int>(&outputMatrix_d, inputRow * inputColumn);

	// allocate memory to hold convoluted matrix in host
	outputMatrix = (int*) malloc( inputRow * inputColumn * sizeof(int));

	start = clock();
	// call the convolution function to be executed on the device
	convoluteAsFilter<<<inputRow, inputColumn>>>(inputMatrix_d, kernel_d, kernelRow, kernelColumn, inputColumn, outputMatrix_d);
	end = clock() - start;

	//copy the output matrix from GOU device to Host
	copyFromDevice<int>(outputMatrix, outputMatrix_d, inputRow * inputColumn);

	//print the output matrix
	printMatrixRowMajor("convoluted matrix from GPU", outputMatrix, inputRow, inputColumn);
	fprintf(fp, "\nGPU time taken = %f\n\n", (double) end / (double) CLOCKS_PER_SEC);
	printf("\nGPU time taken = %f\n\n", (double) end / (double) CLOCKS_PER_SEC);

	//call the convolution function to be executed on host
	start = clock();
	convoluteInHost(inputMatrix, inputRow, inputColumn, kernel, kernelRow, kernelColumn, outputMatrix);
	end = clock() - start;
	//print the output matrix
	printMatrixRowMajor("convoluted matrix from Host", outputMatrix, inputRow, inputColumn);
	printf( "\nPC time taken = %f\n\n", (double) end / (double) CLOCKS_PER_SEC);
	fprintf(fp, "\nPC time taken = %f\n\n", (double) end / (double) CLOCKS_PER_SEC);

	// wait for user key
	getchar(); getchar();

	//free the allocated memory
	free(outputMatrix); free(inputMatrix); free(kernel);
	freeDeviceMemory(3, inputMatrix_d, kernel_d, outputMatrix_d);
	fclose(fp);

	return 0;
}
