package com.temenos.test.client;

public class TestByte {
	public static void main(String [] args)
	{
		String header  ="0x000C";
		show_mem_rep (header.toCharArray(),4);
		
	}
	
	public static void show_mem_rep(char [] start, int n)
	{
	    int i;
	    for (i = 0; i < n; i++)
	         System.out.printf(" %b", start[i]);
	    
	}

}
