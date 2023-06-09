package com.temenos.microservice.payments.api.test;

import static com.temenos.microservice.framework.test.dao.TestDbUtil.populateCriterian;
import static com.temenos.microservice.payments.util.ITConstants.API_KEY;
import static com.temenos.microservice.payments.util.ITConstants.BASE_URI;
import static com.temenos.microservice.payments.util.ITConstants.JWT_TOKEN_HEADER_NAME;
import static com.temenos.microservice.payments.util.ITConstants.JWT_TOKEN_HEADER_VALUE;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.reactive.function.client.WebClient;

import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.test.dao.Attribute;
import com.temenos.microservice.framework.test.dao.Criterion;
import com.temenos.microservice.framework.test.dao.DaoFacade;
import com.temenos.microservice.framework.test.dao.DaoFactory;
import com.temenos.microservice.framework.test.dao.Item;

import io.netty.util.internal.StringUtil;

/**
 * TODO: Document me!
 *
 * @author vinods
 *
 */
public class ITTest {

	public static DaoFacade daoFacade = DaoFactory.getInstance();
	protected WebClient client;
	static Properties endpointProperties = new Properties();
	/**
	 * Returns new web client.
	 * 
	 * @return
	 */
	public static WebClient newWebClient() {
		String apiKey = getApiKey();
		WebClient.Builder builder = WebClient.builder();
		builder.baseUrl(getUri());
		builder.defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE);
		try {
			givenKeyCloakRequestHeader(builder,JWT_TOKEN_HEADER_NAME, JWT_TOKEN_HEADER_VALUE);
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if (!StringUtil.isNullOrEmpty(apiKey)) {
			builder.defaultHeader(API_KEY, apiKey);
		}
		return builder.build();
	}

	/**
	 * Return URI from system property if missing in system property then usegivenKeyCloakRequestHeader
	 * default.
	 * 
	 * @return uri
	 */
	public static String getUri() {
		String uri = Environment.getEnvironmentVariable("URI", "");
		if (uri == null || uri == "") {
			uri = BASE_URI;
		}
		assert (uri != null);
		return uri;
	}

	public static String getApiKey() {
		return Environment.getEnvironmentVariable("API_KEY", "");
	}

	public static String getCode(String var) {
		String codeValue = "?code=" + Environment.getEnvironmentVariable(var, "");
		return codeValue;
	}
	public static String getCodetest(String var) {
		String codeValue = "&code=" + Environment.getEnvironmentVariable(var, "");
		return codeValue;
	}
	

	protected static void deletePaymentOrderRecord(String table, String... query) {
		List<Criterion> criterions = new ArrayList<Criterion>();
		int pos = 0;
		criterions.add(populateCriterian(query[pos++], query[pos++], query[pos++], query[pos++]));
		criterions.add(populateCriterian(query[pos++], query[pos++], query[pos++], query[pos++]));
		daoFacade.deleteItems(table, criterions);
	}

	protected static void deleteAllRecords(String table) {
		List<Criterion> criterions = new ArrayList<Criterion>();
		daoFacade.deleteItems(table, criterions);
	}

	protected static Map<Integer, List<Attribute>> readPaymentOrderRecord(String table, String... query) {
		List<Criterion> criterions = new ArrayList<Criterion>();
		int pos = 0;
		criterions.add(populateCriterian(query[pos++], query[pos++], query[pos++], query[pos++]));
		criterions.add(populateCriterian(query[pos++], query[pos++], query[pos++], query[pos++]));
		return daoFacade.readItems(table, criterions);
	}

	protected static void createReferenceDataRecord(String tableName, String... query) {
		Item item = new Item();
		item.setTableName(tableName);
		List<Attribute> attributeList = new ArrayList<>();
		int rowCount = 0;
		int attributeCount = query.length / 3;
		for (int i = 0; i < attributeCount; i++) {
			Attribute attribute = new Attribute();
			attribute.setName(query[rowCount++]);
			attribute.setDataType(query[rowCount++]);
			attribute.setValue(query[rowCount++]);
			attributeList.add(attribute);
		}
		item.setAttributes(attributeList);
		daoFacade.createRecord(item);
	}

	protected static String readFromFile(String fileName) {
		FileInputStream fis = null;
		byte[] buffer = new byte[1000];
		StringBuilder sb = new StringBuilder();
		try {
			fis = new FileInputStream(fileName);

			while (fis.read(buffer) != -1) {
				sb.append(new String(buffer));
				buffer = new byte[10];
			}
			fis.close();

		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (fis != null)
				try {
					fis.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
		return sb.toString();
	}

	public static void clearRecords(String paymentOrderId, String debitAccount) {
		deleteAllRecords("ms_reference_data");
		deleteAllRecords("PaymentOrder_extension");
		deleteAllRecords("PaymentMethod_extension");
		deleteAllRecords("ExchangeRate_extension");
		deleteAllRecords("Card_extension");
		deleteAllRecords("PayeeDetails_extension");
		deleteAllRecords("ms_payment_order_ExchangeRate");
		deleteAllRecords("ms_payment_order");
		deleteAllRecords("PaymentMethod");
		deleteAllRecords("Card");
		deleteAllRecords("ExchangeRate");
		deleteAllRecords("PayeeDetails");
	}
	
    private static void givenKeyCloakRequestHeader(WebClient.Builder builder,String headerName, String headerValue) throws Throwable {
        
        endpointProperties.load(new FileInputStream(new File("src/test/resources/end-point.properties")));
       
        if(headerName.equals("Authorization") && Environment.getEnvironmentVariable("KeycloakEnabled", "").isEmpty()==false)
        {
           
        System.out.println("Keycloak Auth code: "+endpointProperties.getProperty("keyCloak_Authorization").toString());
        builder.defaultHeader(headerName, endpointProperties.getProperty("keyCloak_Authorization").toString());
       
        }
       
        else
        {
        	builder.defaultHeader(headerName, headerValue);
        }
    }
}