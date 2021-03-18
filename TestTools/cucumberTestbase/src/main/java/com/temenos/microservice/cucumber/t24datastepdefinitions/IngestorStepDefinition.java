package com.temenos.microservice.cucumber.t24datastepdefinitions;

import static com.temenos.microservice.framework.test.dao.TestDbUtil.populateCriterian;
import static com.temenos.microservice.test.util.ResourceHandler.readResource;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.temenos.des.schema.exception.EventSchemaParseException;
import com.temenos.des.serializer.serialize.exception.AvroSerializationException;
import com.temenos.des.serializer.serialize.exception.SchemaRegistryException;
import com.temenos.des.streamprocessor.exception.StreamProducerException;
import com.temenos.des.streamvendorio.core.stream.produce.StreamProducer;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.test.dao.Attribute;
import com.temenos.microservice.framework.test.dao.Criterion;
import com.temenos.microservice.framework.test.dao.DaoFacade;
import com.temenos.microservice.framework.test.dao.DaoFactory;
import com.temenos.microservice.framework.test.streams.ITestProducer;
import com.temenos.microservice.framework.test.util.ITtestStreamTopicReader;
import com.temenos.microservice.test.DataTablesColumnNames;
import com.temenos.microservice.test.TestCase;
import com.temenos.microservice.test.producer.AvroProducer;
import com.temenos.microservice.test.producer.ProducerFactory;
import com.temenos.microservice.test.util.BuildRequest;
import com.temenos.microservice.test.util.IngesterUtil;
import com.temenos.microservice.test.util.ResourceHandler;
import com.temenos.microservice.test.util.RetryUtil;
import com.temenos.useragent.cucumber.steps.CucumberInteractionSession;
import com.temenos.useragent.cucumber.steps.ScenarioBundleStepDefs;

import cucumber.api.DataTable;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

public class IngestorStepDefinition {
	@Autowired
	private CucumberInteractionSession cucumberInteractionSession;
	@Autowired
	private ScenarioBundleStepDefs scenarioBundleStepDefs;
	private static final Logger log = LoggerFactory.getLogger(RetryUtil.class);
	private static final String REPLACE_COMPANY = "COMPANY_ID_HERE";
	private static final String REPLACE_TESTCASE_ID = "TEST_CASE_ID_HERE";
	private DaoFacade daoFacade = null;

	private String apiName;

	private TestCase testCase;
	private AvroProducer avroProducer;
	private ProducerFactory createStreamProducer;
	private ITestProducer t24Producer;
	private List<Criterion> dataCriterions = null;
	private String dbName;
	private String vendorName;
	Map<Integer, List<Attribute>> dataMap = null;

	@Given("^Set the test backgound for (HOLDINGS|CALL_BACK_REGISTRY|ENTITLEMENT|MARKETING_CATALOG|PARTY|PAYMENT_ORDER|SO|EVENT_STORE|FAMS|AMS|ADAPTER|MICROSERVICE) API$")
	public void setTestBackground(String apiName) throws Exception {
		this.apiName = apiName;
	}

	@Given("^Set the Testcase id ([^\\s]+) for company ([^\\s]+)$")
	public void setTestCaseID(String testCaseID, String companyID) throws Exception {
		testCase = new TestCase(testCaseID, apiName);
		testCase.setCompanyID(companyID);
		log.info("Running test case {}", testCaseID);

	}

	@Given("^Delete Record in the table ([^\\s]+) for the following criteria$")
	public void deleteRecordsInTable(String tableName, DataTable dataTable) throws Exception {
		 dbName = Environment.getEnvironmentVariable("DB_VENDOR", "");
		 vendorName = Environment.getEnvironmentVariable("DB_VENDOR", "");
		dataCriterions = new ArrayList<>();
		List<Map<String, String>> tableValues = dataTable.asMaps(String.class, String.class);
		tableValues.forEach(tableValue -> {
			if (tableValue.get(DataTablesColumnNames.TEST_CASE_ID.getName()).equals(testCase.getTestCaseID())) {
				dataCriterions.add(populateCriterian(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()),
						tableValue.get(DataTablesColumnNames.COLUMN_OPERATOR.getName()),
						tableValue.get(DataTablesColumnNames.COLUMN_DATATYPE.getName()),
						tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName())));
			}
		});
		if (isAwsInboxOutboxTable(tableName,vendorName,dbName)) {
			tableName = dbName.replace('_', '-') + "." + tableName;
		}
		log.info("Deleting records in table {} for testcase {}", tableName, testCase.getTestCaseID());
		daoFacade = DaoFactory.getInstance();
		daoFacade.openConnection();
		daoFacade.deleteItems(tableName, dataCriterions);
	}
	
	private boolean isAwsInboxOutboxTable(String tableName, String vendorName,String dbName) {
		return "DYNAMODB".equalsIgnoreCase(vendorName) && dbName.contains("_")
				&& ((tableName.contains("ms_inbox_events")) || (tableName.contains("ms_outbox_events")));
	}

	@When("^Send Data to Topic from file ([^\\s]+) for Application ([^\\s]+)$")
	public void sendDataToTopic(String resourcePath, String applicationName) throws Exception {
		avroProducer = new AvroProducer("table-update-holdings",
				Environment.getEnvironmentVariable("localSchemaNamesAsCSVOrRemoteSchemaURL", "http://localhost:8083"));
		testCase.setT24Payload(readResource("/" + resourcePath));
		avroProducer.sendGenericEvent(testCase.getT24Payload(), applicationName);
	}

	// To send data to the topic name mentioned in step ex: When send data to topic
	// <topic name>
	@When("^Send Data to Topic ([^\\s]+) from file ([^\\s]+) for Application ([^\\s]+)$")
	public void sendDataToMentionedTopic(String topicName, String resourcePath, String applicationName)
			throws Exception {

		if (topicName.equals("ms-paymentorder-inbox-topic") == true
				|| topicName.equals("paymentorder-event-topic") == true)

		{
			StreamProducer producer = ProducerFactory.createStreamProducer("itest",
					Environment.getEnvironmentVariable("temn.msf.stream.vendor", "kafka"));
			String content = new String(Files.readAllBytes(Paths.get("src/test/resources/" + resourcePath)));
			System.out.println("content:" + content);

			if (IngesterUtil.isCloudEvent()) {
				producer.batch().add(topicName, IngesterUtil.packageCloudEvent(new String(content).getBytes()));
			} else {
				producer.batch().add(topicName, new String(content).getBytes());
			}

			try {
				producer.batch().send();
			} catch (StreamProducerException e) {
				e.printStackTrace();
			}
		} else {
			throw new Exception("Topic name: " + topicName + " is incorrect");
		}

	}
	   
	   //To check json data content in topic
	   @Then("^check if json data with event id ([^\\s]+) and type ([^\\s]+) is present in topic ([^\\s]+)$")
	    public void checkJSONInTopic(String eventId, String eventType, String topicName) throws Exception {
	       
	       Map<String, JSONObject> streamTopicResult = ITtestStreamTopicReader.getTopicValueByCommandType(topicName,eventId, eventType);
	       assertTrue("There is no entry for the Event Id:"+eventId+" , Event Type: "+eventType+" combination in the topic: "+topicName,!streamTopicResult.isEmpty());
	   }
	
	 //To check json data content in topic(added by Sai Kushaal)
	   @Then("^check if json data with correlation id ([^\\s]+) and type ([^\\s]+) is present in topic ([^\\s]+)$")
	    public void checkJSONInTopicByCorrelationId(String correlationId, String eventType, String topicName) throws Exception {
	       
	       Map<String, JSONObject> streamTopicResult = ITtestStreamTopicReader.getTopicValueByCorrelationId(topicName,correlationId, eventType);
	       assertTrue("There is no entry for the Correlation Id:"+correlationId+" , Event Type: "+eventType+" combination in the topic: "+topicName,!streamTopicResult.isEmpty());
	   }
	   
	   //To check avro data content in topic(added by Sai Kushaal)
	   @Then("^check if avro data with event id ([^\\s]+) is present in topic ([^\\s]+)$")
	    public void checkAvroInTopicByEventId(String eventId,String topicName) throws Exception {
	       
	       Map<String, JSONObject> streamTopicResult = ITtestStreamTopicReader.getAvroTopicValueByEventId(topicName,eventId);
	       assertTrue("There is no entry for the event Id:"+eventId+" in the topic: "+topicName,!streamTopicResult.isEmpty());
	   }
	
	
	
    //To send data to the topic name mentioned in step ex: When send data to topic <topic name>
  @When("^send JSON data to topic ([^\\s]+) from file ([^\\s]+) for Application ([^\\s]+)$")
  public void sendJSONDataToMentionedTopic(String topicName,String resourcePath, String applicationName) throws Exception {
      

         StreamProducer producer = ProducerFactory.createStreamProducer("itest", Environment.getEnvironmentVariable("temn.msf.stream.vendor", "kafka"));
          String content = new String(Files.readAllBytes(Paths.get("src/test/resources/"+resourcePath)));
          System.out.println("content:" + content);
          
              producer.batch().add(topicName, UUID.randomUUID().toString(), new String(content).getBytes());
          
          try {
              producer.batch().send();
          } catch (StreamProducerException e) {
              e.printStackTrace();
          }
}
	// To send data to the topic name mentioned in step ex: When send data to topic
	// <topic name>
	@When("^Send Data to Topic ([^\\s]+) for following records$")
	public void sendDataToMentionedTopics(String topicName, DataTable dataTable) throws Exception {
		System.setProperty("temn.msf.ingest.sink.stream", topicName);
		avroProducer = new AvroProducer("table-update-holdings",
				Environment.getEnvironmentVariable("localSchemaNamesAsCSVOrRemoteSchemaURL", "http://localhost:8083"));
		List<Map<String, String>> tableValues = dataTable.asMaps(String.class, String.class);
		tableValues.forEach(tableValue -> {
			if (tableValue.get(DataTablesColumnNames.TEST_CASE_ID.getName()).equals(testCase.getTestCaseID())) {
				try {
					testCase.setT24Payload(
							readResource("/" + tableValue.get(DataTablesColumnNames.AVRO_JSON.getName())));
				} catch (IOException e) {
					throw new RuntimeException(e);
				}
				try {
					avroProducer.sendGenericEvent(testCase.getT24Payload(),
							tableValue.get(DataTablesColumnNames.APPLICATION_NAME.getName()));
				} catch (IOException | StreamProducerException | InterruptedException | AvroSerializationException
						| EventSchemaParseException | SchemaRegistryException e) {
					throw new RuntimeException(e);
				}
			}
		});
	}

	@When("^Send Data to Topic for following records$")
	public void sendDataToTopic(DataTable dataTable) throws Exception {
		avroProducer = new AvroProducer("table-update-holdings",
				Environment.getEnvironmentVariable("localSchemaNamesAsCSVOrRemoteSchemaURL", "http://localhost:8083"));
		List<Map<String, String>> tableValues = dataTable.asMaps(String.class, String.class);
		tableValues.forEach(tableValue -> {
			if (tableValue.get(DataTablesColumnNames.TEST_CASE_ID.getName()).equals(testCase.getTestCaseID())) {
				try {
					testCase.setT24Payload(
							readResource("/" + tableValue.get(DataTablesColumnNames.AVRO_JSON.getName())));
				} catch (IOException e) {
					throw new RuntimeException(e);
				}
				try {
					avroProducer.sendGenericEvent(testCase.getT24Payload(),
							tableValue.get(DataTablesColumnNames.APPLICATION_NAME.getName()));
				} catch (IOException | StreamProducerException | InterruptedException | AvroSerializationException
						| EventSchemaParseException | SchemaRegistryException e) {
					throw new RuntimeException(e);
				}
			}
		});
	}

	@Then("^Set the following data criteria$")
	public void setDataCriteria(DataTable dataTable) throws Exception {
		dataCriterions = new ArrayList<>();
		List<Map<String, String>> tableValues = dataTable.asMaps(String.class, String.class);
		tableValues.forEach(tableValue -> {
			if (tableValue.get(DataTablesColumnNames.TEST_CASE_ID.getName()).equals(testCase.getTestCaseID())) {
				if (tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()) != null) {
					dataCriterions.add(populateCriterian(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()),
							tableValue.get(DataTablesColumnNames.COLUMN_OPERATOR.getName()),
							tableValue.get(DataTablesColumnNames.COLUMN_DATATYPE.getName()),
							tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName())));
				} else {
					dataCriterions.add(populateCriterian(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()),
							tableValue.get(DataTablesColumnNames.COLUMN_OPERATOR.getName()),
							tableValue.get(DataTablesColumnNames.COLUMN_DATATYPE.getName()),
							MSGenericActionStepDefs.DbcolumnValues
									.get(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()))));
					// System.out.println(MSGenericActionStepDefs.DbcolumnValues.get(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName())));
				}
			}
		});
	}

	// To use bundle(with value) under Column value while setting the criteria
	@Then("^Set the following data criteria with bundle value$")
	public void setDataCriteriaWithBundleValue(DataTable dataTable) throws Exception {
		dataCriterions = new ArrayList<>();
		List<Map<String, String>> tableValues = dataTable.asMaps(String.class, String.class);
		tableValues.forEach(tableValue -> {
			if (tableValue.get(DataTablesColumnNames.TEST_CASE_ID.getName()).equals(testCase.getTestCaseID())) {
				if (tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()) != null
						&& cucumberInteractionSession.scenarioBundle()
								.getString(tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName())) != null) {

					dataCriterions.add(populateCriterian(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()),
							tableValue.get(DataTablesColumnNames.COLUMN_OPERATOR.getName()),
							tableValue.get(DataTablesColumnNames.COLUMN_DATATYPE.getName()),
							cucumberInteractionSession.scenarioBundle()
									.getString(tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()))));

					System.out.println("Bundle value :" + cucumberInteractionSession.scenarioBundle()
							.getString(tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName())));

				} else if (tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()) != null) {
					dataCriterions.add(populateCriterian(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()),
							tableValue.get(DataTablesColumnNames.COLUMN_OPERATOR.getName()),
							tableValue.get(DataTablesColumnNames.COLUMN_DATATYPE.getName()),
							tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName())));
				}

			}
		});

	}

	@Then("^Validate the below details from the db table ([^\\s]+)$")
	public void validateDetailsFromDB(String tableName, DataTable dataTable) throws Exception {
		 dbName = Environment.getEnvironmentVariable("DB_NAME", "");
		 vendorName = Environment.getEnvironmentVariable("DB_VENDOR", "");
		dataMap = RetryUtil.getWithRetry(300, () -> {
			daoFacade = DaoFactory.getInstance();
			daoFacade.openConnection();
			Map<Integer, List<Attribute>> dataMap = daoFacade.readItems(
					(isAwsInboxOutboxTable(tableName,vendorName,dbName)) ? dbName.replace('_', '-') + "." + tableName : tableName,
					dataCriterions);
			return (dataMap.size() != 0 ? dataMap : null);
		}, " Getting DB records from table: "
				+ ((isAwsInboxOutboxTable(tableName,vendorName,dbName)) ? dbName.replace('_', '-') + "." + tableName : tableName));
		List<Attribute> data = dataMap.get(Integer.valueOf(1));
		List<Map<String, String>> tableValues = dataTable.asMaps(String.class, String.class);
		tableValues.forEach(tableValue -> {
			if (tableValue.get(DataTablesColumnNames.TEST_CASE_ID.getName()).equals(testCase.getTestCaseID())) {
				data.forEach(attribute -> {
					if (attribute.getName().equals(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()))) {
						assertEquals(
								getDataMismatchErrorLog(
										(isAwsInboxOutboxTable(tableName,vendorName,dbName)) ? dbName.replace('_', '-') + "." + tableName
												: tableName,
										tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()),
										tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()),
										attribute.getValue()),
								tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()),
								attribute.getValue().toString());
					}
				});
			}
		});
	}
	
	@Then("^Validate the below details from the db table ([^\\s]+) vendorname ([^\\s]+) dbname ([^\\s]+)$")
	public void validateDetailsFromDB(String tableName,String vendorName, String dbName, DataTable dataTable) throws Exception {
		dataMap = RetryUtil.getWithRetry(300, () -> {
			daoFacade = DaoFactory.getInstance(vendorName);
			daoFacade.openConnection(vendorName, dbName);
			Map<Integer, List<Attribute>> dataMap = daoFacade.readItems(
					(isAwsInboxOutboxTable(tableName,vendorName,dbName)) ? dbName.replace('_', '-') + "." + tableName : tableName,
					dataCriterions);
			return (dataMap.size() != 0 ? dataMap : null);
		}, " Getting DB records from table: "
				+ ((isAwsInboxOutboxTable(tableName,vendorName,dbName)) ? dbName.replace('_', '-') + "." + tableName : tableName));
		List<Attribute> data = dataMap.get(Integer.valueOf(1));
		List<Map<String, String>> tableValues = dataTable.asMaps(String.class, String.class);
		tableValues.forEach(tableValue -> {
			if (tableValue.get(DataTablesColumnNames.TEST_CASE_ID.getName()).equals(testCase.getTestCaseID())) {
				data.forEach(attribute -> {
					if (attribute.getName().equals(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()))) {
						assertEquals(
								getDataMismatchErrorLog(
										tableName,
								tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()),
										tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()),
										attribute.getValue()),
								tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()),
								attribute.getValue().toString());
					}
				});
			}
		});
		daoFacade.closeConnection();
	}

	@Then("^Validate the below details and bundle value from the db table ([^\\s]+)$")
	public void validateDetailsAndBundleValueFromDB(String tableName, DataTable dataTable) throws Exception {
		dataMap = RetryUtil.getWithRetry(300, () -> {
			daoFacade = DaoFactory.getInstance();
			daoFacade.openConnection();
			Map<Integer, List<Attribute>> dataMap = daoFacade.readItems(tableName, dataCriterions);
			return (dataMap.size() != 0 ? dataMap : null);
		}, " Getting DB records from table: " + tableName);
//          if (dataMap.size() >= 2) {
//              throw new Exception("more than 1 record in table " + tableName + " for testcase " + testCase.getTestCaseID());
//          }
		List<Attribute> data = dataMap.get(Integer.valueOf(1));
		List<Map<String, String>> tableValues = dataTable.asMaps(String.class, String.class);
		tableValues.forEach(tableValue -> {
			if (tableValue.get(DataTablesColumnNames.TEST_CASE_ID.getName()).equals(testCase.getTestCaseID())) {
				data.forEach(attribute -> {
					if (attribute.getName().equals(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()))
							&& cucumberInteractionSession.scenarioBundle()
									.getString(tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName())) != null) {
						assertEquals(
								getDataMismatchErrorLog(tableName,
										tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()),
										cucumberInteractionSession.scenarioBundle().getString(
												tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName())),
										attribute.getValue()),
								cucumberInteractionSession.scenarioBundle()
										.getString(tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName())),
								attribute.getValue());
						// tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()),
						// attribute.getValue().toString());
					}

					else if (attribute.getName().equals(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()))) {
						assertEquals(getDataMismatchErrorLog(tableName,
								tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()),
								tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()), attribute.getValue()),
								tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()),
								attribute.getValue().toString());
					}
				});
			}
		});
	}
	
	
	  @Then("^Validate if the below columns contains values from the db table ([^\\s]+)$")
	    public void validateColumnContainValuesInDB(String tableName, DataTable dataTable) throws Exception {
		   dbName =Environment.getEnvironmentVariable("DB_NAME", "");
		   vendorName = Environment.getEnvironmentVariable("DB_VENDOR", "");
	      dataMap = RetryUtil.getWithRetry(300, () -> {
	    	daoFacade = DaoFactory.getInstance();
	  		daoFacade.openConnection();
			Map<Integer, List<Attribute>> dataMap = daoFacade.readItems(
					(isAwsInboxOutboxTable(tableName,vendorName,dbName)) ? dbName.replace('_', '-') + "." + tableName : tableName,
					dataCriterions);
	            return (dataMap.size() != 0 ? dataMap : null);
		}, " Getting DB records from table: "
				+ ((isAwsInboxOutboxTable(tableName,vendorName,dbName)) ? dbName.replace('_', '-') + "." + tableName : tableName));
	        List<Attribute> data = dataMap.get(Integer.valueOf(1));
	        List<Map<String, String>> tableValues = dataTable.asMaps(String.class, String.class);
	        tableValues.forEach(tableValue -> {
	            if (tableValue.get(DataTablesColumnNames.TEST_CASE_ID.getName()).equals(testCase.getTestCaseID())) {
	                data.forEach(attribute -> {
	                    if (attribute.getName().equals((tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName())))) {
						assertTrue(
								"Actual value against column " + attribute.getName() + " in DB ie :"
										+ attribute.getValue() + " doesnt contain value mentioned in script ie: "
										+ tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()),
								attribute.getValue().toString().contains(
										tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()).toString()));

	                    }
	                });
	            }
	        });
	    }
	

	// To check if an entry is not present in DB
	@Then("^Validate if below details not present in db table ([^\\s]+)$")
	public void validateDetailsNotInDB(String tableName, DataTable dataTable) throws Exception {
		daoFacade = DaoFactory.getInstance();
		daoFacade.openConnection();
		Map<Integer, List<Attribute>> dataMap = daoFacade.readItems(tableName, dataCriterions);
		System.out.println("map content" + dataMap);
		System.out.println("map size" + dataMap.size());

		if (dataMap.size() > 0) {
			throw new Exception("a record in table " + tableName + " is present for this transaction");
		}
	}

	// To check entries in DB table and also the no of rows for the mentioned
	// criteria/condition
	@Then("^Validate the below details from the db table ([^\\s]+) and check no of record is (.*)$")
	public void validateDetailsFromDBAndRecordCount(String tableName, int recordCount, DataTable dataTable)
			throws Exception {
		 dbName =Environment.getEnvironmentVariable("DB_NAME", "");
		 vendorName = Environment.getEnvironmentVariable("DB_VENDOR", "");
		dataMap = RetryUtil.getWithRetry(300, () -> {
			daoFacade = DaoFactory.getInstance();
			daoFacade.openConnection();
			Map<Integer, List<Attribute>> dataMap = daoFacade.readItems(
					(isAwsInboxOutboxTable(tableName,vendorName,dbName)) ? dbName.replace('_', '-') + "." + tableName : tableName,
					dataCriterions);
			return (dataMap.size() != 0 ? dataMap : null);
		}, " Getting DB records from table: "
				+ ((isAwsInboxOutboxTable(tableName,vendorName,dbName)) ? dbName.replace('_', '-') + "." + tableName : tableName));
		if (dataMap.size() != recordCount) {
			throw new Exception("record(s) in table " + tableName + " is not equal to no of records " + recordCount
					+ " specified in step");
		}
		List<Attribute> data = dataMap.get(Integer.valueOf(1));
		List<Map<String, String>> tableValues = dataTable.asMaps(String.class, String.class);
		tableValues.forEach(tableValue -> {
			if (tableValue.get(DataTablesColumnNames.TEST_CASE_ID.getName()).equals(testCase.getTestCaseID())) {
				data.forEach(attribute -> {
					if (attribute.getName().equals(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()))) {
						assertEquals(
								getDataMismatchErrorLog(
										(isAwsInboxOutboxTable(tableName,vendorName,dbName)) ? dbName.replace('_', '-') + "." + tableName
												: tableName,
								tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()),
										tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()),
										attribute.getValue()),
								tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()),
								attribute.getValue().toString());
					}
				});
			}
		});
	}
	
	// To check entries in DB table and also the no of rows for the mentioned
		// criteria/condition
		@Then("^Validate the below details from the db table ([^\\s]+) of vendorname ([^\\s]+) dbname ([^\\s]+) and check no of record is (.*)$")
		public void validateDetailsFromDBAndRecordCount(String tableName,String vendorName, String dbName,int recordCount,DataTable dataTable)
				throws Exception {
			dataMap = RetryUtil.getWithRetry(300, () -> {
				daoFacade = DaoFactory.getInstance(vendorName);
				daoFacade.openConnection(vendorName, dbName);
				Map<Integer, List<Attribute>> dataMap = daoFacade
						.readItems((isAwsInboxOutboxTable(tableName, vendorName, dbName))
								? dbName.replace('_', '-') + "." + tableName
								: tableName, dataCriterions);
				return (dataMap.size() != 0 ? dataMap : null);
			}, " Getting DB records from table: " + ((isAwsInboxOutboxTable(tableName, vendorName, dbName))
					? dbName.replace('_', '-') + "." + tableName
					: tableName));
			if (dataMap.size() != recordCount) {
				throw new Exception("record(s) in table " + tableName + " is not equal to no of records " + recordCount
						+ " specified in step");
			}
			List<Attribute> data = dataMap.get(Integer.valueOf(1));
			List<Map<String, String>> tableValues = dataTable.asMaps(String.class, String.class);
			tableValues.forEach(tableValue -> {
				if (tableValue.get(DataTablesColumnNames.TEST_CASE_ID.getName()).equals(testCase.getTestCaseID())) {
					data.forEach(attribute -> {
						if (attribute.getName().equals(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()))) {
							assertEquals(
									getDataMismatchErrorLog(
											(isAwsInboxOutboxTable(tableName, vendorName, dbName))
													? dbName.replace('_', '-') + "." + tableName
													: tableName,
											tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()),
											tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()),
											attribute.getValue()),
									tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()),
									attribute.getValue().toString());
						}
					});
				}
			});
			daoFacade.closeConnection();
		}
	
	@Then("^associate below column values with bundle from the db table ([^\\s]+)$")
    public void assocDBValuesToBundle(String tableName, DataTable dataTable) throws Exception {
        dataMap = RetryUtil.getWithRetry(300, () -> {
        	daoFacade = DaoFactory.getInstance();
    		daoFacade.openConnection();
            Map<Integer, List<Attribute>> dataMap = daoFacade.readItems(tableName, dataCriterions);
            return (dataMap.size() != 0 ? dataMap : null);
        }, " Getting DB records from table: " + tableName);
//          if (dataMap.size() >= 2) {
//              throw new Exception("more than 1 record in table " + tableName + " for testcase " + testCase.getTestCaseID());
//          }
        List<Attribute> data = dataMap.get(Integer.valueOf(1));
        List<Map<String, String>> tableValues = dataTable.asMaps(String.class, String.class);
        tableValues.forEach(tableValue -> {
            if (tableValue.get(DataTablesColumnNames.TEST_CASE_ID.getName()).equals(testCase.getTestCaseID())) {
                data.forEach(attribute -> {
                    if (attribute.getName().equals(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()))) {
                     
                        cucumberInteractionSession.scenarioBundle().put(tableValue.get(DataTablesColumnNames.BUNDLE_NAME.getName()), tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()).toString());
                    }
                    
                    System.out.println(DataTablesColumnNames.COLUMN_NAME.getName().toString()+"value is "+DataTablesColumnNames.COLUMN_VALUE.getName().toString());

                });
            }
        });
    }
	
	
	

	private String getDataMismatchErrorLog(String tableName, Object columnName, Object expected, Object actual) {
		return "For testcase: " + testCase.getTestCaseID() + " Data mismatch in table: " + tableName + " for column"
				+ columnName.toString() + " expected value: " + expected.toString() + " actual value: "
				+ actual.toString();
	}

	@When("^Build (POST|PUT) Request with the json file ([^\\s]+)$")
	public void sendRequest(String requestType, String fileLocation) throws Exception {
		BuildRequest buildRequest = new BuildRequest(testCase.getApiUnderTest());
		buildRequest.setBodyMessage(ResourceHandler.readResource("/" + fileLocation));
		buildRequest.buildRequest();
		buildRequest.sendRequest();
	}

	@After
	public void tearDown() {
		if (avroProducer != null) {
			avroProducer.close();
		}
		if (t24Producer != null) {
			t24Producer.cleanup();
		}
		if (daoFacade != null) {
			daoFacade.closeConnection();
		}
	}

}