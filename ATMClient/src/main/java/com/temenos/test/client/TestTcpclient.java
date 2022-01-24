package com.temenos.test.client;

import java.net.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.time.Duration;
import java.time.Instant;
import java.io.*;

public class TestTcpclient {

	public static void main(String[] args) {
		String hostname = "localhost";
		int port = 3221 ;// 3222 ; // ;   7004;
		//https://stackoverflow.com/questions/34835702/send-from-tcp-client-to-netty-server-data-how-bytebuf-readint-work
		//https://netty.io/4.0/api/io/netty/handler/codec/LengthFieldBasedFrameDecoder.html
		//https://github.com/nickman/camel-netty/blob/master/src/test/resources/org/apache/camel/component/netty/local-multiple-codecs.xml
		
		//String testmsg = "02B20200F33AC401A8E090620000000006C20002164879170090360802002000000000066300122415055200000000078718090550122412251225541105108990920011111111111111374879170090360802D25122010118000000000035908002100089200947660000892     Wal-Mart Super Center  ANKENY       IAUS8401111111111111111011001000080150171900050021000084005633ITS           1000000000002500000000                  08217641670025500022829F030120000000000009F26016445F16AE5D7ED5DE8200418009F3600400089F340064200009F020120000000663009F270028084014A00000009808409F1001406011203A020009F09004008D9F33006E0D8C89F1A0038409A0062012249F35002229501080800480005F2A0038409F410060047779C002009F370003480FD7708691020F9A8C858D82C3FE33030000007Z384044";
		String testmsg = "06900200F33AC401A8E090620000000006C20002164879170090360802002000000000066300122415055200000000078718090550122412251225541105108990920011111111111111374879170090360802D25122010118000000000035908002100089200947660000892     Wal-Mart Super Center  ANKENY       IAUS8401111111111111111011001000080150171900050021000084005633ITS           1000000000002500000000                  08217641670025500022829F030120000000000009F26016445F16AE5D7ED5DE8200418009F3600400089F340064200009F020120000000663009F270028084014A00000009808409F1001406011203A020009F09004008D9F33006E0D8C89F1A0038409A0062012249F35002229501080800480005F2A0038409F410060047779C002009F370003480FD7708691020F9A8C858D82C3FE33030000007Z384044";
		//String testmsg = "0200F33AC401A8E090620000000006C20002164879170090360802002000000000066300122415055200000000078718090550122412251225541105108990920011111111111111374879170090360802D25122010118000000000035908002100089200947660000892     Wal-Mart Super Center  ANKENY       IAUS8401111111111111111011001000080150171900050021000084005633ITS           1000000000002500000000                  08217641670025500022829F030120000000000009F26016445F16AE5D7ED5DE8200418009F3600400089F340064200009F020120000000663009F270028084014A00000009808409F1001406011203A020009F09004008D9F33006E0D8C89F1A0038409A0062012249F35002229501080800480005F2A0038409F410060047779C002009F370003480FD7708691020F9A8C858D82C3FE33030000007Z384044";
		String expectedResponse ="03170210F23A4001AEE084000000000004000002164879170090360802002000000000066300122415055207871709055012241225541108990920011111111111111374879170090360802D2512201011800000000003590800210070039176089200947660000892     Wal-Mart Super Center  ANKENY       IAUS8400402002000-0000000000002001000-0000000000000821764167007Z384044";
		int msgcounter =0;
		int TOTAL_MESSAGECOUNT = 10;
		
		try (Socket socket = new Socket(hostname, port)) {

			OutputStream output = socket.getOutputStream();
			//PrintWriter writer = new PrintWriter(output, true);
			BufferedWriter writer1 = new BufferedWriter(new OutputStreamWriter(output));

			InputStream input = socket.getInputStream();
			BufferedReader reader = new BufferedReader(new InputStreamReader(input));
			while (true) {
				msgcounter++;
				Instant start = Instant.now();
				writer1.write(testmsg);
				
				writer1.flush();
				//writer.println(testmsg);
				int i;
				StringBuffer respLength = new StringBuffer();
				int counter = 0;
				
				while ((i = reader.read()) != -1) {
						
					char [] headerarray = new char[4];
					char ch  = (char) i;
					respLength.append(ch);					
					counter++;
					
					if (counter == i) {
						System.out.print(respLength);
						int length = Integer.parseInt(respLength.toString());
						
						char[] dataarray = new char[length];
						int data = reader.read(dataarray, 0, length);
						String responseMsg =  new String(dataarray).trim();
						Instant end = Instant.now();
						Duration timeElapsed = Duration.between(start, end);
						System.out.println("Time taken: "+ timeElapsed.toMillis() +" milliseconds");
						System.out.println ("Header length: ["+length + "]Response data length :["+responseMsg.length()+"]");
						
						System.out.println("TCP CLIENT: Response Data Received  [" + responseMsg+"]");
						if(dataarray!=null) {
							recordResponse(respLength.toString() +  responseMsg);
						}
						System.out.println ("Response Message received count :"+msgcounter);
						counter = 0;
						respLength = new StringBuffer();
						break;
					}
				}
				
				if(msgcounter==TOTAL_MESSAGECOUNT)
				{
					System.out.println ("Message exchanged target reached:"+msgcounter);
					break;
				}

			}

		} catch (UnknownHostException ex) {

			System.out.println("Server not found: " + ex.getMessage());

		} catch (IOException ex) {

			System.out.println("I/O error: " + ex.getMessage());
		}

	}
	
	private static void recordResponse(String response)
	{
		
		String fileName = "output/tcpresponse.log";
		 
		//Use try-with-resource to get auto-closeable writer instance
		try {
			 FileWriter fw = new FileWriter(fileName, true);
			    BufferedWriter bw = new BufferedWriter(fw);
			    bw.write(response);
			    bw.newLine();
			    bw.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	

}
