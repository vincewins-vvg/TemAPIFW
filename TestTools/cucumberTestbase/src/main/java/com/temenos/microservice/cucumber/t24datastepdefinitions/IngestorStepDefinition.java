package com.temenos.microservice.cucumber.t24datastepdefinitions;

import static com.temenos.microservice.framework.test.dao.TestDbUtil.populateCriterian;
import static com.temenos.microservice.test.util.ResourceHandler.readResource;
import static org.junit.Assert.assertEquals;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.temenos.des.schema.exception.EventSchemaParseException;
import com.temenos.des.serializer.serialize.exception.AvroSerializationException;
import com.temenos.des.serializer.serialize.exception.SchemaRegistryException;
import com.temenos.des.streamprocessor.exception.StreamProducerException;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.test.dao.Attribute;
import com.temenos.microservice.framework.test.dao.Criterion;
import com.temenos.microservice.framework.test.dao.DaoFacade;
import com.temenos.microservice.framework.test.dao.DaoFactory;
import com.temenos.microservice.framework.test.streams.ITestProducer;
import com.temenos.microservice.test.DataTablesColumnNames;
import com.temenos.microservice.test.TestCase;
import com.temenos.microservice.test.producer.AvroProducer;
import com.temenos.microservice.test.util.BuildRequest;
import com.temenos.microservice.test.util.ResourceHandler;
import com.temenos.microservice.test.util.RetryUtil;

import cucumber.api.DataTable;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;

public class IngestorStepDefinition {

    private static final Logger log = LoggerFactory.getLogger(RetryUtil.class);
    private static final String REPLACE_COMPANY = "COMPANY_ID_HERE";
    private static final String REPLACE_TESTCASE_ID = "TEST_CASE_ID_HERE";
    private DaoFacade daoFacade = DaoFactory.getInstance();

    private String apiName;
   
    private TestCase testCase;
    private AvroProducer avroProducer;
    private ITestProducer t24Producer;
    private List<Criterion> dataCriterions = null;
    Map<Integer, List<Attribute>> dataMap = null;

    @Before
    public void setUp() {
        if (daoFacade != null) {
            daoFacade.openConnection();
        }
    }

    @Given("^Set the test backgound for (HOLDINGS|CALL_BACK_REGISTRY|ENTITLEMENT|MARKETING_CATALOG|PARTY|PAYMENT_ORDER|SO|EVENT_STORE|FAMS|AMS) API$")
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
        log.info("Deleting records in table {} for testcase {}", tableName, testCase.getTestCaseID());
        daoFacade.deleteItems(tableName, dataCriterions);
    }

    @When("^Send Data to Topic from file ([^\\s]+) for Application ([^\\s]+)$")
    public void sendDataToTopic(String resourcePath, String applicationName) throws Exception {
        avroProducer = new AvroProducer("table-update-holdings", Environment
                .getEnvironmentVariable("localSchemaNamesAsCSVOrRemoteSchemaURL", "http://localhost:8083"));
        testCase.setT24Payload(readResource("/" + resourcePath));
        avroProducer.sendGenericEvent(testCase.getT24Payload(), applicationName);
    }
    
    //To send data to the topic name mentioned in step ex: When send data to topic <topic name>
    @When("^Send Data to Topic (.*) from file ([^\\s]+) for Application ([^\\s]+)$")
    public void sendDataToMentionedTopic(String topicName,String resourcePath, String applicationName) throws Exception {
        System.setProperty("temn.msf.ingest.sink.stream", topicName);
        avroProducer = new AvroProducer("table-update-holdings", Environment
                .getEnvironmentVariable("localSchemaNamesAsCSVOrRemoteSchemaURL", "http://localhost:8083"));
        testCase.setT24Payload(readResource("/" + resourcePath));
        avroProducer.sendGenericEvent(testCase.getT24Payload(), applicationName);
    }

    @When("^Send Data to Topic for following records$")
    public void sendDataToTopic(DataTable dataTable) throws Exception {
        avroProducer = new AvroProducer("table-update-holdings", Environment
                .getEnvironmentVariable("localSchemaNamesAsCSVOrRemoteSchemaURL", "http://localhost:8083"));
        List<Map<String, String>> tableValues = dataTable.asMaps(String.class, String.class);
        tableValues.forEach(tableValue -> {
            if (tableValue.get(DataTablesColumnNames.TEST_CASE_ID.getName()).equals(testCase.getTestCaseID())) {
                try {
                    testCase.setT24Payload(readResource("/" + tableValue.get(DataTablesColumnNames.AVRO_JSON.getName())));
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
                try {
                    avroProducer.sendGenericEvent(testCase.getT24Payload(),
                            tableValue.get(DataTablesColumnNames.APPLICATION_NAME.getName()));
                } catch (IOException | StreamProducerException | InterruptedException |
                        AvroSerializationException |  EventSchemaParseException | SchemaRegistryException e) {
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
                if(tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName())!=null) {
                     dataCriterions.add(populateCriterian(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()),
                            tableValue.get(DataTablesColumnNames.COLUMN_OPERATOR.getName()),
                            tableValue.get(DataTablesColumnNames.COLUMN_DATATYPE.getName()),
                            tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName())));
                }
                else{
                    dataCriterions.add(populateCriterian(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()),
                            tableValue.get(DataTablesColumnNames.COLUMN_OPERATOR.getName()),
                            tableValue.get(DataTablesColumnNames.COLUMN_DATATYPE.getName()),
                            MSGenericActionStepDefs.DbcolumnValues.get(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()))));
                    //System.out.println(MSGenericActionStepDefs.DbcolumnValues.get(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName())));
                }
            }
        });
    } 

    @Then("^Validate the below details from the db table ([^\\s]+)$")
    public void validateDetailsFromDB(String tableName, DataTable dataTable) throws Exception {
      dataMap = RetryUtil.getWithRetry(60, () -> {
            Map<Integer, List<Attribute>> dataMap = daoFacade.readItems(tableName, dataCriterions);
            return (dataMap.size() != 0 ? dataMap : null);
        }, " Getting DB records from table: " + tableName);
//        if (dataMap.size() >= 2) {
//            throw new Exception("more than 1 record in table " + tableName + " for testcase " + testCase.getTestCaseID());
//        }
        List<Attribute> data = dataMap.get(Integer.valueOf(1));
        List<Map<String, String>> tableValues = dataTable.asMaps(String.class, String.class);
        tableValues.forEach(tableValue -> {
            if (tableValue.get(DataTablesColumnNames.TEST_CASE_ID.getName()).equals(testCase.getTestCaseID())) {
                data.forEach(attribute -> {
                    if (attribute.getName().equals(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()))) {
                        assertEquals(getDataMismatchErrorLog(tableName, tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()),
                                tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()), attribute.getValue()),
                                tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()), attribute.getValue().toString());
                    }
                });
            }
        });
    }
    
    //To check if an entry is not present in DB
    @Then("^Validate if below details not present in db table ([^\\s]+)$")
    public void validateDetailsNotInDB(String tableName, DataTable dataTable) throws Exception {
//      dataMap = RetryUtil.getWithRetry(60, () -> {
            Map<Integer, List<Attribute>> dataMap = daoFacade.readItems(tableName, dataCriterions);
            System.out.println("map content"+dataMap);
            System.out.println("map size" +dataMap.size());

        if (dataMap.size() > 0) {
            throw new Exception("a record in table " + tableName + " is present for this transaction");
        }
    }

    //To check entries in DB table and also the no of rows for the mentioned criteria/condition
    @Then("^Validate the below details from the db table ([^\\s]+) and check no of record is (.*)$")
    public void validateDetailsFromDBAndRecordCount(String tableName, int recordCount, DataTable dataTable) throws Exception {
      dataMap = RetryUtil.getWithRetry(60, () -> {
            Map<Integer, List<Attribute>> dataMap = daoFacade.readItems(tableName, dataCriterions);
            return (dataMap.size() != 0 ? dataMap : null);
        }, " Getting DB records from table: " + tableName);
        if (dataMap.size() != recordCount) {
            throw new Exception("record(s) in table " + tableName + " is not equal to no of records "+recordCount+" specified in step");
        }
        List<Attribute> data = dataMap.get(Integer.valueOf(1));
        List<Map<String, String>> tableValues = dataTable.asMaps(String.class, String.class);
        tableValues.forEach(tableValue -> {
            if (tableValue.get(DataTablesColumnNames.TEST_CASE_ID.getName()).equals(testCase.getTestCaseID())) {
                data.forEach(attribute -> {
                    if (attribute.getName().equals(tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()))) {
                        assertEquals(getDataMismatchErrorLog(tableName, tableValue.get(DataTablesColumnNames.COLUMN_NAME.getName()),
                                tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()), attribute.getValue()),
                                tableValue.get(DataTablesColumnNames.COLUMN_VALUE.getName()), attribute.getValue().toString());
                    }
                });
            }
        });
    }

    
    
    private String getDataMismatchErrorLog(String tableName, Object columnName, Object expected, Object actual) {
        return "For testcase: " + testCase.getTestCaseID() + " Data mismatch in table: "
                + tableName + " for column" + columnName.toString() + " expected value: " + expected.toString() + " actual value: " + actual.toString();
    }


    @When("^Build (POST|PUT) Request with the json file ([^\\s]+)$")
    public void sendRequest(String requestType,String fileLocation) throws Exception {
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
