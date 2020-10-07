package com.temenos.microservice.payments.ingester.test;

import static com.temenos.microservice.payments.util.ITConstants.API_KEY;
import static com.temenos.microservice.payments.util.ITConstants.BASE_URI;
import static com.temenos.microservice.framework.test.dao.TestDbUtil.populateCriterian;
import static org.junit.Assert.assertEquals;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.reactive.function.client.WebClient;

import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.test.dao.Attribute;
import com.temenos.microservice.framework.test.dao.Criterion;
import com.temenos.microservice.framework.test.dao.DaoFacade;
import com.temenos.microservice.framework.test.dao.DaoFactory;

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
		if (!StringUtil.isNullOrEmpty(apiKey)) {
			builder.defaultHeader(API_KEY, apiKey);
		}
		return builder.build();
	}

	/**
	 * Return URI from system property if missing in system property then use
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

	protected static void deleteInboxRecord(String table, String... query) {
		List<Criterion> criterions = new ArrayList<Criterion>();
		int pos = 0;
		criterions.add(populateCriterian(query[pos++], query[pos++], query[pos++], query[pos++]));
		criterions.add(populateCriterian(query[pos++], query[pos++], query[pos++], query[pos++]));
		daoFacade.deleteItems(table, criterions);
	}

	protected static void deleteOutboxRecord(String table, String... query) {
		List<Criterion> criterions = new ArrayList<Criterion>();
		int pos = 0;
		criterions.add(populateCriterian(query[pos++], query[pos++], query[pos++], query[pos++]));
		criterions.add(populateCriterian(query[pos++], query[pos++], query[pos++], query[pos++]));
		daoFacade.deleteItems(table, criterions);
	}

	protected static Map<Integer, List<Attribute>> readInboxRecord(String eventId, String eventType) {
		List<Criterion> criterions = new ArrayList<>();
		criterions.add(populateCriterian("eventId", "eq", "string", eventId));
		criterions.add(populateCriterian("eventType", "eq", "string", eventType));

		String inboxTableName = "";
		if ("DYNAMODB".equalsIgnoreCase(Environment.getEnvironmentVariable("DB_VENDOR", ""))) {
			inboxTableName = "PaymentOrder.ms_inbox_events";
		} else {
			inboxTableName = "ms_inbox_events";
		}
		return daoFacade.readItems(inboxTableName, criterions);
	}

	protected static Map<Integer, List<Attribute>> readOutboxRecord(String eventId, String eventType) {
		List<Criterion> criterions = new ArrayList<>();
		criterions.add(populateCriterian("eventId", "eq", "string", eventId));
		criterions.add(populateCriterian("eventType", "eq", "string", eventType));

		String outboxTableName = "";
		if ("DYNAMODB".equalsIgnoreCase(Environment.getEnvironmentVariable("DB_VENDOR", ""))) {
			outboxTableName = "PaymentOrder.ms_outbox_events";
		} else {
			outboxTableName = "ms_outbox_events";
		}
		return daoFacade.readItems(outboxTableName, criterions);
	}

	protected JSONObject apiRequest(String url, String httpMethod) throws IOException, ParseException {
		URL urlForGetRequest = new URL(url);
		String readLine = null;
		JSONObject apiResponse = new JSONObject();
		int responseCode, retryCount = 0, maxRetryCount = 4;
		HttpURLConnection conection;
		do {
			conection = (HttpURLConnection) urlForGetRequest.openConnection();
			conection.setRequestProperty("x-api-key", Environment.getEnvironmentVariable("API_KEY", ""));
			conection.setRequestMethod(httpMethod);
			responseCode = conection.getResponseCode();
			retryCount = retryCount + 1;
		} while (responseCode != HttpURLConnection.HTTP_OK && retryCount < maxRetryCount);
		assertEquals(HttpURLConnection.HTTP_OK, responseCode);
		if (responseCode == HttpURLConnection.HTTP_OK) {
			BufferedReader in = new BufferedReader(new InputStreamReader(conection.getInputStream()));
			StringBuffer response = new StringBuffer();
			while ((readLine = in.readLine()) != null) {
				response.append(readLine);
			}
			in.close();
			System.out.println("JSON String Result " + response.toString());
			JSONParser parser = new JSONParser();
			apiResponse = new JSONObject(response.toString());
		} else {
			System.out.println("Error while hitting the API");
		}
		return apiResponse;
	}
}
