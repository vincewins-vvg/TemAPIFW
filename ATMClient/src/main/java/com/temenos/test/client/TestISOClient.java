package com.temenos.test.client;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.Socket;
import java.net.UnknownHostException;
import java.nio.ByteBuffer;
import java.time.Duration;
import java.time.Instant;
import java.util.Arrays;
import java.util.List;

/*
 * This is a client program which connects to netty TCP
 * and helps to test the ISO message
 *
 * 
 */

public class TestISOClient {

	public static void main(String[] args) {
		String hostname = "localhost";
		// Change the port according to the configuration
		int port = 3221;

		// Sample ISO message
		String sampleISOMsg = "0200F33AC401A8E090620000000006C20002164879170090360802002000000000066300122415055200000000078899090550122412251225541105108990920011111111111111374879170090360802D25122010118000000000035908002100089200947660000892     Wal-Mart Super Center  ANKENY       IAUS8401111111111111111011001000080150171900050021000084005633ITS           1000000000002500000000                  08217641670025500022829F030120000000000009F26016445F16AE5D7ED5DE8200418009F3600400089F340064200009F020120000000663009F270028084014A00000009808409F1001406011203A020009F09004008D9F33006E0D8C89F1A0038409A0062012249F35002229501080800480005F2A0038409F410060047779C002009F370003480FD7708691020F9A8C858D82C3FE33030000007Z384044";
		List<String> messages = Arrays.asList(sampleISOMsg, sampleISOMsg);

		int msgcounter = 0;

		sendAndReceiveISOMsg(hostname, port, sampleISOMsg, messages, msgcounter);

	}

	/*
	 * This method creates a socket connection and sends the sample message to the
	 * camel netty tcp component as a byte array along and receives back the
	 * response
	 * 
	 * 
	 */

	public static void sendAndReceiveISOMsg(String hostname, int port, String sampleISOMsg, List<String> messages,
			int msgcounter) {
		try (Socket socket = new Socket(hostname, port)) {

			OutputStream output = socket.getOutputStream();
			InputStream input = socket.getInputStream();
			BufferedReader reader = new BufferedReader(new InputStreamReader(input));

			Instant start = Instant.now();
			writeMessagesWithHeader(sampleISOMsg, output);
			messages.forEach(message -> {
				try {
					writeMessagesWithHeader(message, output);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			});
			output.flush();

			byte[] headerarray = new byte[4];

			while (input.read(headerarray, 0, 4) != -1) {
				msgcounter++;
				ByteBuffer bb = ByteBuffer.wrap(headerarray);
				int bytesToRead = bb.getInt();
				System.out.println(bytesToRead);

				char[] dataarray = new char[bytesToRead];
				int data1 = reader.read(dataarray, 0, bytesToRead);
				String responseMsg = new String(dataarray).trim();
				Instant end = Instant.now();
				Duration timeElapsed = Duration.between(start, end);
				System.out.println("Time taken: " + timeElapsed.toMillis() + " milliseconds");
				System.out.println("Request data length: [" + sampleISOMsg.length() + "]Response data length :["
						+ responseMsg.length() + "]");

				System.out.println("TCP CLIENT: Response Data Received w/o header [" + responseMsg + "]");

				System.out.println("Response Message received count :" + msgcounter);

			}
			input.close();
			output.close();

		} catch (UnknownHostException ex) {

			System.out.println("Server not found: " + ex.getMessage());

		} catch (IOException ex) {

			System.out.println("I/O error: " + ex.getMessage());
		}
	}

	public static void writeMessagesWithHeader(String sampleISOMsg, OutputStream output) throws IOException {
		final byte[] msgLengthInBytes = getMessageLengthInBytes(sampleISOMsg);
		output.write(msgLengthInBytes);
		output.write(sampleISOMsg.getBytes());
	}

	public static byte[] getMessageLengthInBytes(String sampleISOMsg) {
		byte[] data = null;
		try {
			data = sampleISOMsg.getBytes("utf-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		int length = data.length;
		final byte[] msgLengthInBytes = getHeaderAsBytes(length);
		return msgLengthInBytes;
	}

	private static byte[] getHeaderAsBytes(int length) {
		final byte[] msgLengthInBytes = new byte[4];
		msgLengthInBytes[3] = (byte) length;
		msgLengthInBytes[2] = (byte) ((int) length >>> 8);
		msgLengthInBytes[1] = (byte) ((int) length >>> 16);
		msgLengthInBytes[0] = (byte) ((int) length >>> 24);
		return msgLengthInBytes;
	}

}
