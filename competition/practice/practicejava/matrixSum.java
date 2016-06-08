/*******************************************************************************
 * Copyright (c) 2016 Arulkumar (arul.csecit@ymail.com).
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Arulkumar (arul.csecit@ymail.com)
 *******************************************************************************/
import java.io.*;
import java.util.InputMismatchException;


class InputReader
{
	private InputStream stream;
	private byte[] buffer = new byte[1024];
	private int currentChar;
	private int numChars;
	
	/**
	 * constructor
	 * @param stream
	 */
	public InputReader(InputStream stream) {
		super();
		this.stream = stream;
	}

	/**
	 * read a byte
	 * @return
	 */
	
	public int read()
	{
		if(numChars == -1) throw new InputMismatchException();
		
		//if the current character index is greater than total characters in buffer
		if(currentChar >= numChars){
			currentChar = 0;
			try{
				numChars = stream.read(buffer);
				
			} catch(IOException ex)
			{
				throw new InputMismatchException();
			}
			
			//if no characters are read, return -1
			if(numChars <= 0) return -1;

		}
		
		return buffer[currentChar++];
		
	}
	
	/**
	 * read an integer
	 * @return
	 */
	public int readInt()
	{
		int c = read();
		if(isSpaceChar(c)) c = read();
		int sign = 1;
		if(c == '-') { sign = -1; c = read(); }
		
		int result = 0;
		do {
			if(c < '0' || c > '9') throw new InputMismatchException();
			result = result * 10; 
			result = result + c - '0';
			c = read();
		}while(!isSpaceChar(c));
		
		return result * sign;
	}

	/**
	 * read an long
	 * @return
	 */
	public long readLong()
	{
		int c = read();
		if(isSpaceChar(c)) c = read();
		int sign = 1;
		if(c == '-') { sign = -1; c = read(); }
		
		long result = 0;
		do {
			if(c < '0' || c > '9') throw new InputMismatchException();
			result = result * 10; 
			result = result + c - '0';
			c = read();
		}while(!isSpaceChar(c));
		
		return result * sign;
	}
	
	
	/**
	 * read a string
	 * @return
	 */
	public String readString()
	{
		int c = read();
		while(isSpaceChar(c)) c = read();
		
		StringBuilder str = new StringBuilder();
		do{
			str.appendCodePoint(c);
			c = read();
		}while(!isSpaceChar(c));
		
		return str.toString();
	}
	
	/**
	 * check if the given number is space
	 * @param c
	 * @return
	 */
	private boolean isSpaceChar(int c)
	{
		return c == ' ' || c == '\n' || c == '\r' || c == '\t' || c == -1;
	}
	
	/**
	 * read next string
	 * @return
	 */
	public String next() {
		return readString();
	}
}

public class matrixSum {

	public static void main(String[] args)
	{
		InputReader in = new InputReader(System.in);
		int nrows, ncols;
		int[][] matrix;	
		int[][] sum;
		
		nrows = in.readInt();
		ncols = in.readInt();
		matrix = new int[nrows][ncols];
		sum = new int[nrows][ncols];
		
		//read the matrix and calculate matrix sums
		for (int i = 0; i < nrows; i++) {
			for (int j = 0; j < ncols; j++) {
				int currentInput = in.readInt();
				sum[i][j] = currentInput + getSum(sum, i, j-1, nrows, ncols) + getSum(sum, i-1, j, nrows, ncols)
									- getSum(sum, i-1, j-1, nrows, ncols);
			}
		}
		
		//read number of queries
		int Q = in.readInt();
		
		for (int i = 0; i < Q; i++) {
			int X = in.readInt();
			int Y = in.readInt();
			System.out.println(sum[X-1][Y-1]);
		}
	}

	private static int getSum(int[][] sum, int i, int j, int nrows, int ncols) {
		if(i >= 0 && i < nrows &&
				j >= 0 && j < ncols)
		{
			return sum[i][j];
		}
		return 0;
	}
}
