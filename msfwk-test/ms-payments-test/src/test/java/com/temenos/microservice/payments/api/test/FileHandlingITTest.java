package com.temenos.microservice.payments.api.test;

import static com.temenos.microservice.payments.util.ITConstants.JWT_TOKEN_HEADER_NAME;
import static com.temenos.microservice.payments.util.ITConstants.JWT_TOKEN_HEADER_VALUE;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.json.JSONObject;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;
import org.springframework.web.reactive.function.client.WebClient;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.WebResource.Builder;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;
import com.sun.jersey.core.header.FormDataContentDisposition;
import com.sun.jersey.multipart.FormDataMultiPart;
import com.sun.jersey.multipart.MultiPart;
import com.sun.jersey.multipart.file.FileDataBodyPart;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.test.dao.Attribute;

import junit.framework.Assert;

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
		if ("MYSQL".equals(Environment.getEnvironmentVariable("DB_VENDOR", "")) ||  "SQLSERVER".equals(Environment.getEnvironmentVariable("DB_VENDOR", "")) ||  "POSTGRES".equals(Environment.getEnvironmentVariable("DB_VENDOR", ""))) {
			deleteAllRecords("ms_file_upload");
		} else {
			deletePaymentOrderRecord("ms_file_upload", "name", "eq", "string", "textresult.txt", "mimetype", "eq",
					"string", "text/plain");
		}
		daoFacade.closeConnection();
	}

	//@Test
	public void testAFileUpload() {
		String uri = getUri();
		uri = uri + "/v1.0.0/payments/upload" + ITTest.getCode("FILE_UPLOAD_AUTH_CODE");
		final ClientConfig config = new DefaultClientConfig();
		final Client client = Client.create(config);
		final WebResource resource = client.resource(uri);
		ClassLoader classLoader = getClass().getClassLoader();
		File f = new File(classLoader.getResource("testupload.txt").getFile());
		FileDataBodyPart fileDataBodyPart = new FileDataBodyPart("file", f);
		fileDataBodyPart
				.setContentDisposition(FormDataContentDisposition.name("documentFile").fileName(f.getName()).build());
		final JSONObject jsonToSend = new JSONObject();
		jsonToSend.put("documentId", "1234");
		jsonToSend.put("documentName", "TextFile");
		final MultiPart multiPart = new FormDataMultiPart().field("documentDetails", jsonToSend.toString())
				.bodyPart(fileDataBodyPart);
		multiPart.setMediaType(MediaType.MULTIPART_FORM_DATA_TYPE);
		Builder builder = resource.type(MediaType.MULTIPART_FORM_DATA_TYPE);
		try {
			givenKeyCloakRequestHeader(builder,JWT_TOKEN_HEADER_NAME,JWT_TOKEN_HEADER_VALUE);
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		ClientResponse response=builder.post(ClientResponse.class, multiPart);
		Map<Integer, List<Attribute>> insertedRecord = readPaymentOrderRecord("ms_file_upload", "name", "eq", "string",
				"testupload.txt", "mimetype", "eq", "string", "text/plain");
		List<Attribute> entry = insertedRecord.get(1);
		assertNotNull(entry);
		client.destroy();
	}

	@Ignore
	public void testFileDownload() {
		String uri = getUri();
		uri = uri + "/v1.0.0/payments/download/testupload.txt" + ITTest.getCode("FILE_DOWNLOAD_AUTH_CODE");
		javax.ws.rs.client.Client client = ClientBuilder.newClient();
		Response response = client.target(uri).request().header(JWT_TOKEN_HEADER_NAME, JWT_TOKEN_HEADER_VALUE).get();
		try {
			InputStream in = (InputStream) response.getEntity();
			InputStreamReader isReader = new InputStreamReader(in);
			BufferedReader reader = new BufferedReader(isReader);
			StringBuffer sb = new StringBuffer();
			String str;
			while ((str = reader.readLine()) != null) {
				sb.append(str);
			}
			System.out.println("Response : " + sb.toString());
			assertTrue(sb.toString().contains("The multipart/byteranges content type"));
		} catch (Exception e) {
			Assert.fail(e.getMessage());
		}
	}
	
    private static void givenKeyCloakRequestHeader(Builder builder,String headerName, String headerValue) throws Throwable {
        
        endpointProperties.load(new FileInputStream(new File("src/test/resources/end-point.properties")));
       
        if(headerName.equals("Authorization") && Environment.getEnvironmentVariable("KeycloakEnabled", "").isEmpty()==false)
        {
           
        System.out.println("Keycloak Auth code: "+endpointProperties.getProperty("keyCloak_Authorization").toString());
        builder.header(headerName, endpointProperties.getProperty("keyCloak_Authorization").toString());
       
        }
       
        else
        {
        	builder.header(headerName, headerValue);
        }
    }
}
