package com.temenos.microservice.payments.api.test;

import static com.temenos.microservice.payments.util.ITConstants.JSON_BODY_TO_FILEUPLOAD;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.SQLException;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Response;

import org.glassfish.jersey.media.multipart.FormDataMultiPart;
import org.glassfish.jersey.media.multipart.MultiPartFeature;
import org.glassfish.jersey.media.multipart.file.FileDataBodyPart;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

import com.temenos.microservice.framework.core.conf.Environment;

import junit.framework.Assert;

@Ignore
public class FileHandlingITTest extends ITTest {

	@Before
	public void setUp() throws SQLException {
		this.client = newWebClient();
	}

	@BeforeClass
	public static void initializeData() {
		daoFacade.openConnection();
	}

	@AfterClass
	public static void clearData() {
		if ("MYSQL".equals(Environment.getEnvironmentVariable("DB_VENDOR", ""))) {
			deleteAllRecords("ms_file_upload");
		} else {
			deletePaymentOrderRecord("ms_file_upload", "name", "eq", "string", "textresult.txt");
		}
		daoFacade.closeConnection();
	}

	@Test
	public void testAFileUpload() {
		System.out.println("Started !! ");
		String uri = getUri();
		uri = uri + "/payments/upload" + ITTest.getCode("FILE_UPLOAD_AUTH_CODE");
		final Client client = ClientBuilder.newBuilder().register(MultiPartFeature.class).build();
		ClassLoader classLoader = getClass().getClassLoader();
		File f = new File(classLoader.getResource("testupload.txt").getFile());
		try {
			final FileDataBodyPart filePart = new FileDataBodyPart("file", f);
			FormDataMultiPart formDataMultiPart = new FormDataMultiPart();
			final FormDataMultiPart multipart = (FormDataMultiPart) formDataMultiPart
					.field("documentdetails", JSON_BODY_TO_FILEUPLOAD).bodyPart(filePart);
			final WebTarget target = client.target(uri);
			final Response response = target.request().header("roleId", "ADMIN")
					.post(Entity.entity(multipart, multipart.getMediaType()));
			assertNotNull(response);
			System.out.println("End !! " + response);

			formDataMultiPart.close();
			multipart.close();
		} catch (Exception e) {
			Assert.fail(e.getMessage());
		}
	}
	
	@Test
	public void testFileDownload() {
		String uri = getUri();
		uri = uri + "/payments/download/testupload.txt" + ITTest.getCode("FILE_DOWNLOAD_AUTH_CODE");
		Client client = ClientBuilder.newClient();
		Response response = client.target(uri).request().header("roleId", "ADMIN").get();
		try {
			InputStream in = (InputStream) response.getEntity();
			InputStreamReader isReader = new InputStreamReader(in); 
			BufferedReader reader = new BufferedReader(isReader);
			StringBuffer sb = new StringBuffer();
			String str;
			while ((str = reader.readLine()) != null) {
				sb.append(str);
			}
			System.out.println("download : "+sb.toString());
			assertTrue(sb.toString().contains("The multipart/byteranges content type"));
		} catch (Exception e) {
			Assert.fail(e.getMessage());
		}
	
	}

}
