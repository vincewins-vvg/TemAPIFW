package com.temenos.test.client;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.Socket;
import java.net.UnknownHostException;
import java.nio.ByteBuffer;
import java.time.Duration;
import java.time.Instant;
import java.util.Arrays;
import java.util.List;

import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;

/*
 * This is a client program which connects to netty TCP
 * and helps to test the ISO message with different
 * header types (eg: HEXA and DECIMAL) 
 *
 * 
 */

public class TestSSLISOClientHeaderType {

	public static String headerType = "HEXA";
	private static String reqMsghexLen = "";
	private static String reqMsghexByteLen = "";
	private static int headerLength = 4;

	public static void main(String[] args) {

		String hostname = "localhost";
		// Change the port according to the configuration
		int port = 7000;

		System.out.println("Started");

		// Sample ISO message
		String sampleISOMsg = "0200F638401F28A0A010000060000400000016421498001022408401000000000000050000000000050006081210255212311025140806601100001000000010000000100000001000000006686868374214980010224084391=1200000000000003255689353700087654321 ATM SIMULATOR  GPACK  TEMENOS  CHENNAI 840840003SML00000001000000000001000006100331";

		List<String> messages = Arrays.asList(sampleISOMsg, sampleISOMsg);

		int msgcounter = 0;
		System.out.println("Socket Connection");

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
		// try (Socket socket = new Socket(hostname, port)) {
		try (SSLSocket socket = (SSLSocket) SSLSocketFactory.getDefault().createSocket(hostname, port)) {
			System.out.println("Connection Established");
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

			System.out.println("Output flush");
			byte[] headerarray = new byte[4];

			while (input.read(headerarray, 0, 4) != -1) {
				msgcounter++;
				ByteBuffer bb = ByteBuffer.wrap(headerarray);
				byte[] bbarr = new byte[4];

				int bytesToRead = 0;
				String hexLength = "";
				String hexByteLength = "";
				if ("HEXA".equalsIgnoreCase(headerType)) {
					for (int i = 0; i < 4; i++) {
						byte b = bb.get(i);
						bbarr[i] = b;
					}
					hexLength = new String(bbarr);
					System.out.println("Hex String Resp:: " + hexLength);

					bytesToRead = Integer.parseInt(hexLength, 16);

				} else if ("DECIMAL".equalsIgnoreCase(headerType))
					bytesToRead = bb.getInt();
				else if ("HEXABYTE".equalsIgnoreCase(headerType)) {
					for (int i = 0; i < 4; i++) {
						byte b = bb.get(i);
						bbarr[i] = b;
					}
					
					hexByteLength = new String(bbarr);
					
					bytesToRead = ((bbarr[3] & 0xFF) << 0) + ((bbarr[2] & 0xFF) << 8) + ((bbarr[1] & 0xFF) << 16)
							+ ((bbarr[0] & 0XFF) << 24);
				}

				System.out.println(bytesToRead);

				char[] dataarray = new char[bytesToRead];
				int data1 = reader.read(dataarray, 0, bytesToRead);

				String responseMsg = new String(dataarray).trim();
				Instant end = Instant.now();
				Duration timeElapsed = Duration.between(start, end);
				System.out.println("Time taken: " + timeElapsed.toMillis() + " milliseconds");
				if ("DECIMAL".equalsIgnoreCase(headerType)) {
					System.out.println("Request data length: [" + sampleISOMsg.length() + "]Response data length :["
							+ responseMsg.length() + "]");
					System.out.println("Request msg :: " + sampleISOMsg.length() + sampleISOMsg);
					System.out.println("Response msg :: " + responseMsg.length() + responseMsg);
				} else if ("HEXA".equalsIgnoreCase(headerType)) {
					System.out.println(
							"Request data length: [" + reqMsghexLen + "]Response data length :[" + hexLength + "]");
					System.out.println("Request msg :: " + reqMsghexLen + sampleISOMsg);
					System.out.println("Response msg :: " + hexLength + responseMsg);
				} else if ("HEXABYTE".equalsIgnoreCase(headerType)) {
					System.out.println("Request data length: [" + reqMsghexByteLen + "]Response data length :["
							+ hexByteLength + "]");
					System.out.println("Request msg :: " + reqMsghexByteLen + sampleISOMsg);
					System.out.println("Response msg :: " + hexByteLength + responseMsg);

				}

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
		System.out.println("Write message with header");

		if ("DECIMAL".equalsIgnoreCase(headerType))
			output.write(lengthWriteDecimal(sampleISOMsg.length()));
		else if ("HEXA".equalsIgnoreCase(headerType)) {
			output.write(lengthWriteHexa(sampleISOMsg.length()));
		} else if ("HEXABYTE".equalsIgnoreCase(headerType)) {
			output.write(lengthWriteHexaByte(sampleISOMsg.length()));
		}
		output.write(sampleISOMsg.getBytes());
	}

	public static byte[] lengthWriteDecimal(int length) {
		System.out.println("DECIMAL FLOW");
		ByteBuffer b = ByteBuffer.allocate(4);
		b.putInt(length);
		byte[] result = b.array();

		System.out.println(result);

		return result;

	}

	public static byte[] lengthWriteHexa(int length) {
		System.out.println("HEXA FLOW");
		reqMsghexLen = Integer.toHexString(length);
		while (reqMsghexLen.length() < 4 || (reqMsghexLen.length() > 4 && reqMsghexLen.length() < 8))
			reqMsghexLen = '0' + reqMsghexLen;
		System.out.println(reqMsghexLen);
		byte[] bytes = reqMsghexLen.getBytes();
		return bytes;
	}

	public static byte[] lengthWriteHexaByte(int length) {
		System.out.println("HEXABYTE FLOW");
		byte[] tmplength = null;
		if (headerLength == 2) {
			tmplength = new byte[2];
			tmplength[0] = (byte) ((length >>> 8) & 0xFF);
			tmplength[1] = (byte) ((length >>> 0) & 0xFF);

		} else if (headerLength == 4) {
			tmplength = new byte[4];
			tmplength[0] = (byte) ((length >>> 24) & 0xFF);
			tmplength[1] = (byte) ((length >>> 16) & 0xFF);
			tmplength[2] = (byte) ((length >>> 8) & 0xFF);
			tmplength[3] = (byte) ((length >>> 0) & 0xFF);
		}
		reqMsghexByteLen = new String(tmplength);
		return tmplength;
	}

	final protected static char[] hexArray = "0123456789ABCDEF".toCharArray();

	public static void bytesToHex(byte[] bytes) {
		char[] hexChars = new char[bytes.length * 2];
		for (int j = 0; j < bytes.length; j++) {
			int v = bytes[j] & 0xFF;
			hexChars[j * 2] = hexArray[v >>> 4];
			hexChars[j * 2 + 1] = hexArray[v & 0x0F];
		}
		System.out.println(new String(hexChars));
	}

}