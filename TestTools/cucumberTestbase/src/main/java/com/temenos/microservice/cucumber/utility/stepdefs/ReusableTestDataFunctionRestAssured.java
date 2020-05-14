package com.temenos.microservice.cucumber.utility.stepdefs;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONObject;

import org.json.simple.parser.JSONParser;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.jayway.jsonpath.Configuration;
import com.jayway.jsonpath.DocumentContext;
import com.jayway.jsonpath.JsonPath;
import com.jayway.jsonpath.internal.filter.ValueNode.JsonNode;
import com.jayway.jsonpath.spi.json.JacksonJsonNodeJsonProvider;
import com.jayway.jsonpath.spi.mapper.JacksonMappingProvider;

/**
 * TODO: Document me!
 *
 * @author mohamedasarudeen
 *
 */
public class ReusableTestDataFunctionRestAssured {

	private String requestJsonContents;
	private String expectedStringValueCompare;
	private String actualStringValueCompare;

	public void storeKeyValues(String key, String value, String filePath) {

		try {

			PropertiesConfiguration conf = new PropertiesConfiguration(filePath);
			conf.setProperty(key, value);
			conf.save();

		} catch (Exception io) {
			io.printStackTrace();
		}
	}

	public String updateRequestFileDynamicValues(String jsonpath, String dynamicValue, String jsonFilePath) {
		String modifiedjsoncontent = null;
		try { /* jayway - jsonPath */
			String jsonfilecontents = IOUtils
					.toString(new FileInputStream(System.getProperty("user.dir") + "/" + jsonFilePath));
			DocumentContext requestJsonObject = JsonPath.parse(jsonfilecontents);
			modifiedjsoncontent = requestJsonObject.set(jsonpath, dynamicValue).jsonString();
			IOUtils.write(modifiedjsoncontent,
					new FileOutputStream(System.getProperty("user.dir") + "/" + jsonFilePath), "UTF-8");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return modifiedjsoncontent;

	}

	public String updateArrayRequestFileDynamicValues(String jsonpath, String dynamicValue, String jsonFilePath) {
		String modifiedjsoncontent = null;
		String arrayValue = "[" + dynamicValue + "]";
		try { /* jayway - jsonPath */
			String jsonfilecontents = IOUtils
					.toString(new FileInputStream(System.getProperty("user.dir") + "/" + jsonFilePath));
			DocumentContext requestJsonObject = JsonPath.parse(jsonfilecontents);
			modifiedjsoncontent = requestJsonObject.set(jsonpath, arrayValue).jsonString();
			IOUtils.write(modifiedjsoncontent,
					new FileOutputStream(System.getProperty("user.dir") + "/" + jsonFilePath), "UTF-8");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return modifiedjsoncontent;

	}

	public String updateJsonFileContentsJayWayLib(String jsonArrayPath, String jsonObjectproperty,
			String updatedJsonPropertyValue, String jsonFilePath) throws Exception {

		ObjectMapper mapper = new ObjectMapper();
		String jsonfilecontents = IOUtils

				.toString(new FileInputStream(System.getProperty("user.dir") + "/" + jsonFilePath));
		JSONObject jsonObject = new JSONObject(jsonfilecontents);
		Map<String, String> map = mapper.readValue(jsonfilecontents, Map.class);

		String mailids = map.get(jsonArrayPath);
		System.out.println("mailids : " + mailids);

		JSONArray o1 = new JSONArray(mailids);

		for (int i = 0; i < o1.length(); i++) {

			o1.getJSONObject(i).put(jsonObjectproperty, updatedJsonPropertyValue);

		}

		jsonObject.put(jsonArrayPath, o1.toString().replaceAll("\"", "'"));

		System.out.println("jsonObject : " + jsonObject.toString());

		IOUtils.write(jsonObject.toString(), new FileOutputStream(System.getProperty("user.dir") + "/" + jsonFilePath),
				"UTF-8");

		return jsonObject.toString();

	}

	public String updateJsonFileContentsJayWayLibFeatures(String jsonArrayPath, String jsonObjectproperty,
			String updatedJsonPropertyValue, String jsonFilePath) throws Exception {

		ObjectMapper mapper = new ObjectMapper();
		String jsonfilecontents = IOUtils

				.toString(new FileInputStream(System.getProperty("user.dir") + "/" + jsonFilePath));
		JSONObject jsonObject = new JSONObject(jsonfilecontents);
		Map<String, String> map = mapper.readValue(jsonfilecontents, Map.class);

		String mailids = map.get(jsonArrayPath);
		System.out.println("mailids : " + mailids);

		JSONArray o1 = new JSONArray(mailids);

		for (int i = 0; i < o1.length(); i++) {

			o1.getJSONObject(i).put(jsonObjectproperty, updatedJsonPropertyValue);

		}

		jsonObject.put(jsonArrayPath, o1.toString());

		System.out.println("jsonObject : " + jsonObject.toString());

		IOUtils.write(jsonObject.toString(), new FileOutputStream(System.getProperty("user.dir") + "/" + jsonFilePath),
				"UTF-8");

		return jsonObject.toString();

	}

	public String updateJsonFileContentsJayWayLibPlainArray(String jsonArrayPath, String jsonObjectproperty,
			String updatedJsonPropertyValue, String jsonFilePath) throws Exception {

		JSONParser parser = new JSONParser();
		Object obj = parser
				.parse(IOUtils.toString(new FileInputStream(System.getProperty("user.dir") + "/" + jsonFilePath)));

		org.json.simple.JSONObject jsonObject = (org.json.simple.JSONObject) obj;

		try {

			org.json.simple.JSONArray subjectsJsonArray = (org.json.simple.JSONArray) jsonObject.get(jsonArrayPath);
			System.out.println("SubjectsJsonArray: " + subjectsJsonArray.toString());

			Iterator iterator = subjectsJsonArray.iterator();

			while (iterator.hasNext()) {
				org.json.simple.JSONObject subjectsJsonObjectField = (org.json.simple.JSONObject) iterator.next();

				System.out.println(
						"Json Object value before update : " + subjectsJsonObjectField.get(jsonObjectproperty));

				subjectsJsonObjectField.put(jsonObjectproperty, updatedJsonPropertyValue);

				System.out
						.println("Json Object value after update : " + subjectsJsonObjectField.get(jsonObjectproperty));
			}
			System.out.println("jsonObjectFileContents after update : " + jsonObject.toString());

		} catch (Exception e) {
			e.printStackTrace();
		}

		IOUtils.write(jsonObject.toString(), new FileOutputStream(System.getProperty("user.dir") + "/" + jsonFilePath),
				"UTF-8");

		return jsonObject.toString();

	}

	public String fetchKeyValues(String key, String filePath) {

		try {

			PropertiesConfiguration conf = new PropertiesConfiguration(filePath);
			// conf.getProperties(key);
			return (String) conf.getProperty(key);

		} catch (Exception io) {
			io.printStackTrace();
		}
		return null;

	}

	public String removeExpectedValuesPropertyFile(String filePath) {

		try {

			PrintWriter w = new PrintWriter(filePath);
			w.close();

		} catch (Exception io) {
			io.printStackTrace();
		}
		return null;
	}

	public String compareKeyValuesTextFiles(String expectedKey, String ExpectedfilePath) {

		try {

			PropertiesConfiguration expectedConf = new PropertiesConfiguration(ExpectedfilePath);

			expectedStringValueCompare = (String) expectedConf.getProperty(expectedKey);

			if (expectedStringValueCompare == null) {

				System.out.println(System.lineSeparator() + "<--- Expected Value is null in the property file ---> "
						+ System.lineSeparator() + "Expected Value = " + expectedStringValueCompare
						+ System.lineSeparator());
			}

			else
				assertNotNull("<--- Expected value provided in the text file is not Null ---> ",
						expectedStringValueCompare);

		} catch (Exception io) {
			io.printStackTrace();
		}
		return expectedStringValueCompare;

	}

}
