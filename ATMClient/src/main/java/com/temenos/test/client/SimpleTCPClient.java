package com.temenos.test.client;

import org.apache.commons.codec.binary.Hex;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.Socket;
import java.net.UnknownHostException;
import java.time.Duration;
import java.time.Instant;

public class SimpleTCPClient {
///int maxFrameLength, 
	//int lengthFieldOffset,
	//int lengthFieldLength, 
	//int lengthAdjustment, 
	//int initialBytesToStrip
	
	//io.netty.handler.codec.TooLongFrameException: Adjusted frame length exceeds 1048576: 808464455 - discarded
	
	
	public static void main(String[] args) {
		String hostname = "localhost";
		int port = 3221;
	
		String testmsg = "HELLO, WORLD";
	
		byte[] data =null;
		try {
			data = testmsg.getBytes("utf-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		int length = data.length;
		final byte[] msgLengthInBytes = new byte[4];
		msgLengthInBytes[3] = (byte) length;
		msgLengthInBytes[2] = (byte)  ((int)length >>> 8);
		msgLengthInBytes[1] = (byte) ((int)length >>> 16);
		msgLengthInBytes[0] = (byte) ((int)length >>> 24); 
		
		
		
	
		int msgcounter = 0;

		try (Socket socket = new Socket(hostname, port)) {

			OutputStream output = socket.getOutputStream();
			

			msgcounter++;
			Instant start = Instant.now();
			output.write(msgLengthInBytes);
			output.write(testmsg.getBytes());
		
			//os.writeBytes(testmsg);
			output.flush();
			output.close();
			
			System.out.println("MESSAGE SENT SUCCESFULLY");
		} catch (UnknownHostException ex) {

			System.out.println("Server not found: " + ex.getMessage());

		} catch (IOException ex) {

			System.out.println("I/O error: " + ex.getMessage());
		}

	}
	
	private static byte[] getHeaderAsBytes(int length) {
		final byte[] msgLengthInBytes = new byte[4];
		msgLengthInBytes[3] = (byte) length;
		msgLengthInBytes[2] = (byte)  ((int)length >>> 8);
		msgLengthInBytes[1] = (byte) ((int)length >>> 16);
		msgLengthInBytes[0] = (byte) ((int)length >>> 24);
		return msgLengthInBytes;
	}
	
	
}
