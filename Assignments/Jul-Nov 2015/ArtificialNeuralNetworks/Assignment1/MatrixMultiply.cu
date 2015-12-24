/************************************************

CS6310 Artificial Neural Networks
Assignment 1

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

/**
*  The instructions which will be running in NVIDIA graphics card processor cores.
*
*/
__global__ void multiply(double* matrixA, double* matrixB, int matrixMultInvariant, double* matrixResult)
{
	int matrix1RowStartIndex = blockIdx.x * matrixMultInvariant;
	int matrix2ColumnStartIndex = threadIdx.x * matrixMultInvariant;  // matrixMultInvariant is same as matrix1Column, matrix2Row
	int resultIndex = (blockIdx.x * blockDim.x) + threadIdx.x;
	double multiplicationValue = 0;

	for(int matrix1Index = matrix1RowStartIndex, matrix2Index = matrix2ColumnStartIndex; matrix1Index < (matrix1RowStartIndex + matrixMultInvariant) && matrix2Index < (matrix2ColumnStartIndex + matrixMultInvariant); matrix1Index++, matrix2Index++)
	{
		multiplicationValue += (matrixA[matrix1Index] * matrixB[matrix2Index]);
	}

	matrixResult[resultIndex] = multiplicationValue;

}

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
fill the matrix in row major form randomly
*/
void fillMatrixRowMajor(double* matrix, int matrixRow, int matrixColumn)
{
	for(int rowIndex = 0; rowIndex < matrixRow; rowIndex++)
	{
		for(int columnIndex = 0; columnIndex < matrixColumn; columnIndex++)
		{
			matrix[(rowIndex * matrixColumn) + columnIndex] = rand() % 100;
		}
	}
}

/*
fill the matrix in column major form randomly
*/
void fillMatrixColumnMajor(double* matrix, int matrixRow, int matrixColumn)
{
	for(int rowIndex = 0; rowIndex < matrixRow; rowIndex++)
	{
		for(int columnIndex = 0; columnIndex < matrixColumn; columnIndex++)
		{
			matrix[(columnIndex * matrixRow) + rowIndex] = rand() % 10;
		}
	}
}


/*
 API to print the matrix
*/
void printMatrixRowMajor(char* name, double* matrix, int matrixRow, int matrixColumn)
{
	fprintf(fp, "\n%s (%d x %d)\n\n", name, matrixRow, matrixColumn);

	for(int rowIndex = 0; rowIndex < matrixRow; rowIndex++)
	{
		for(int columnIndex = 0; columnIndex < matrixColumn; columnIndex++)
		{
			fprintf(fp, "%-10.2f", matrix[(rowIndex * matrixColumn) + columnIndex]);
		}
		fprintf(fp, "\n");
	}

	fprintf(fp, "\n");
}

/*
 API to print the matrix
*/
void printMatrixColumnMajor(char* name, double* matrix, int matrixRow, int matrixColumn)
{
	fprintf(fp, "\n%s (%d x %d)\n\n", name, matrixRow, matrixColumn);

	for(int rowIndex = 0; rowIndex < matrixRow; rowIndex++)
	{
		for(int columnIndex = 0; columnIndex < matrixColumn; columnIndex++)
		{
			fprintf(fp, "%-10.2f", matrix[(columnIndex * matrixRow) + rowIndex]);
		}
		fprintf(fp, "\n");
	}

	fprintf(fp, "\n");
}

/*

Matrix multiplication in Host CPU

*/
void multiplyMatrixInHost(double* matrixA, double* matrixB, int matrix1Row, int matrixMultInvariant, int matrix2Column, double* matrixResult)
{

	// loop for all rows of matrixA
	for(int rowIndex = 0; rowIndex < matrix1Row; rowIndex++)
	{
		// loop for all columns of matrixA
		for(int colIndex = 0; colIndex < matrix2Column; colIndex++)
		{
			matrixResult[(rowIndex * matrix2Column) + colIndex] = 0;

			// loop for all internal elements (columns of matrixA, rows of matrixB)
			for(int internalIndex = 0; internalIndex < matrixMultInvariant; internalIndex++)
			{
				matrixResult[(rowIndex * matrix2Column) + colIndex] += (matrixA[(rowIndex * matrixMultInvariant) + internalIndex] * matrixB[(colIndex * matrixMultInvariant) + internalIndex]);
			}
		}
	}
}


/*
*  Matrix multiplication using NVIDIA Graphics card + CUDA C programming  
*
*  Main program entry
*/
int main()
{
	clock_t start, end;
	fp = fopen("Task2_data.txt", "w+");

	/* initialize random seed: */
	srand ((unsigned int)time(NULL));

	int matrix1Row, matrix1Column; 
	int matrix2Row, matrix2Column;  

	//get the total number of columns , rows count of matrices
	printf("\n row count of Matrix-1    : ");
	scanf("%d", &matrix1Row);
	printf("\n column count of Matrix-1 : ");
	scanf("%d", &matrix1Column);
	printf("\n row count of Matrix-2    : ");
	scanf("%d", &matrix2Row);
	printf("\n column count of Matrix-2 : ");
	scanf("%d", &matrix2Column);

	// if the matrices cannot be multiplied, through error and exit the program
	if(matrix1Column != matrix2Row)
	{
		printf("\n\nColumn count of Matrix-1 is not equal to Row count of Matrix-2. So, matrices cannot be multiplied!\n\n");
		fprintf(fp, "\n\nColumn count of Matrix-1 is not equal to Row count of Matrix-2. So, matrices cannot be multiplied!\n\n");

		printf("program will exit now!\n\n");

		getchar();

		fclose(fp);
		exit(0);
	}

	// assume that the matrix1 is stored in row-major format
	double* matrix1; matrix1 = (double*) malloc(matrix1Row * matrix1Column * sizeof(double));
	fillMatrixRowMajor(matrix1, matrix1Row, matrix1Column);

	// assume that the matrix2 is stored in column-major format
	double* matrix2; matrix2 = (double*) malloc(matrix2Row * matrix2Column * sizeof(double));
	fillMatrixColumnMajor(matrix2, matrix2Row, matrix2Column);

	// matrix multiplication result
	double* matrixMultiResult;
	matrixMultiResult = (double*) malloc(matrix1Row * matrix2Column * sizeof(double));

	printMatrixRowMajor("Matrix1", matrix1, matrix1Row, matrix1Column);
	printMatrixColumnMajor("Matrix2", matrix2, matrix2Row, matrix2Column);

	double* matrix1_d;
	double* matrix2_d;
	double* matrixMultiResult_d;

	//copy the input contents to Device
	copyToDevice<double>(matrix1, &matrix1_d, matrix1Row * matrix1Column);
	copyToDevice<double>(matrix2, &matrix2_d, matrix2Row * matrix2Column);
	allocateDeviceMemory<double>(&matrixMultiResult_d, matrix1Row * matrix2Column);

	//MULTIPLICATION IN GPU
	start = clock();
	multiply<<<matrix1Row, matrix2Column>>>(matrix1_d, matrix2_d, matrix1Column, matrixMultiResult_d);
	end = clock() - start;
	// copy result from device to host
	copyFromDevice<double>(matrixMultiResult, matrixMultiResult_d, matrix1Row * matrix2Column);
	printMatrixRowMajor("Multiplication result from GPU Device", matrixMultiResult, matrix1Row, matrix2Column);
	fprintf(fp, "GPU time taken = %f\n\n", (double) end / (double) CLOCKS_PER_SEC);
	printf("GPU time taken = %f\n\n", (double) end / (double) CLOCKS_PER_SEC);

	//MULTIPLICATION IN HOST
	start = clock();
	//do multiplication in Host
	multiplyMatrixInHost(matrix1, matrix2, matrix1Row, matrix1Column, matrix2Column, matrixMultiResult);
	end = clock() - start;
	printMatrixRowMajor("Multiplication result from Host", matrixMultiResult, matrix1Row, matrix2Column);
	printf( "PC time taken = %f\n\n", (double) end / (double) CLOCKS_PER_SEC);
	fprintf(fp, "PC time taken = %f\n\n", (double) end / (double) CLOCKS_PER_SEC);

	//wait for user key
	free(matrixMultiResult); free(matrix1); free(matrix2);
	freeDeviceMemory(3, matrix1_d, matrix2_d, matrixMultiResult_d);

	fclose(fp);

	getchar(); getchar();
	return 0;
}