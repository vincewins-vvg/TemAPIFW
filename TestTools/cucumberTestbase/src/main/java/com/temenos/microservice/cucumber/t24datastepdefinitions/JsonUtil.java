package com.temenos.microservice.cucumber.t24datastepdefinitions;

/*
 * #%L
 * useragent-generic-java
 * %%
 * Copyright (C) 2012 - 2017 Temenos Holdings N.V.
 * %%
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * #L%
 */

import static com.temenos.useragent.generic.mediatype.PropertyNameUtil.extractIndex;
import static com.temenos.useragent.generic.mediatype.PropertyNameUtil.extractPropertyName;
import static com.temenos.useragent.generic.mediatype.PropertyNameUtil.isPropertyNameWithIndex;
import static java.text.MessageFormat.format;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.Random;
import java.util.concurrent.TimeUnit;
import java.util.function.BiConsumer;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;

import com.google.common.base.Throwables;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.useragent.cucumber.steps.CucumberInteractionSession;

import cucumber.api.java8.En;


/**
 * Utility for JSON media-type
 *
 * @author mohamedasarudeen
 *
 */
public final class JsonUtil implements En {
    
    @Autowired
    private static CucumberInteractionSession cucumberInteractionSession;
    
    private static final String DEFAULT_STREAM_KAFKA_BOOTSTRAP_SERVERS = "kafka:29092";
    public static String idFromResponseContents = null;
    
    //jBoss IP and port number will be passed here
    public static String T24_APPSERVER_URL= Environment.getEnvironmentVariable("T24_APPSERVER_URL", "");
    
    private static BiConsumer<String, String> CHECK_VALID_PATH_PART = (String pathPart, String propertyPath) -> {
        if (!isPropertyNameWithIndex(pathPart)) {
            throw new IllegalArgumentException(
                    format("Invalid part {0} in fully qualified property name {1}", pathPart, propertyPath));
        }
    };

    private static BiConsumer<Integer, String> THROW_INVALID_PATH_EXCEPTION = (Integer index, String propertyPath) -> {
        throw new IllegalArgumentException(
                format("Unable to resolve index [{0}] for property path \"{1}\"", index, propertyPath));
    };

    public JsonUtil() {
    }

    /**
     * Flattens the fully qualified property name parts into an array.
     * 
     * <p>
     * For example, fully qualified property name <i>foo(0)/bar(1)/blah</i>
     * would be flattened into an array with <i>3</i> elements as <i>foo(0),
     * bar(1)</i> and <i>blah</i>.
     * </p>
     * 
     * @param fqPropertyName
     * @return array of property name parts 
     */
    public static String[] flattenPropertyName(String fqPropertyName) {
        if (fqPropertyName == null || fqPropertyName.isEmpty()) {
            throw new IllegalArgumentException("Invalid property name '" + fqPropertyName + "'");
        }
        return fqPropertyName.split("/");
    }

    public static Optional<JSONObject> navigateJsonObjectforPropertyPath(Optional<JSONObject> jsonResponse,
            List<String> pathParts, String fqPropertyName, boolean createChild) {
        if (pathParts.isEmpty() || !jsonResponse.isPresent()) {
            return jsonResponse;
        } else {
            String pathPart = pathParts.get(0);
            CHECK_VALID_PATH_PART.accept(pathPart, fqPropertyName);
            Optional<JSONObject> childObject = navigateChild(jsonResponse, extractPropertyName(pathPart),
                    extractIndex(pathPart), createChild);
            return navigateJsonObjectforPropertyPath(childObject, pathParts.subList(1, pathParts.size()),
                    fqPropertyName, createChild);
        }
    }

    public static Optional<JSONObject> navigateChild(Optional<JSONObject> parent, String propertyName, int index,
            boolean createChild) {
        if (parent.isPresent()) {
            // Check and get JSON object
            JSONObject parentJsonObj = parent.get();
            Optional<JSONObject> jsonObj = Optional.ofNullable(parentJsonObj.optJSONObject(propertyName));
            checkValidJsonIndex(jsonObj, index, createChild, propertyName);
            if (jsonObj.isPresent() && index == 0) {
                return jsonObj;
            }

            // Check and get JSON array -> JSON Object
            Optional<JSONArray> jsonArray = Optional.ofNullable(parentJsonObj.optJSONArray(propertyName));
            checkValidJsonIndex(jsonArray, index, createChild, propertyName);
            if (jsonArray.isPresent() && !createChild) {
                return Optional.ofNullable(jsonArray.get().optJSONObject(index));
            }

            // invalid path/object
            if (createChild && index != 0 && !jsonArray.isPresent() && !jsonObj.isPresent()) {
                THROW_INVALID_PATH_EXCEPTION.accept(index, propertyName);
            }

            // add to existing JSON array
            if (createChild && jsonArray.isPresent() && index == jsonArray.get().length()) {
                JSONObject newObject = new JSONObject();
                jsonArray.get().put(index, newObject);
                return Optional.of(newObject);
            }

            // get from existing JSON array
            if (createChild && jsonArray.isPresent() && index < jsonArray.get().length()) {
                return Optional.of((JSONObject) jsonArray.get().get(index));
            }

            // add new JSON item and update parent to JSON array
            if (createChild && jsonObj.isPresent() && index == 1) {
                JSONObject newObject = new JSONObject();
                JSONArray newArray = new JSONArray();
                newArray.put(jsonObj.get());
                newArray.put(newObject);
                parent.get().put(propertyName, newArray);
                return Optional.of(newObject);
            }

            if (createChild) {
                final JSONObject newObject = new JSONObject();
                final JSONArray newArray = new JSONArray();
                newArray.put(newObject);                
                parentJsonObj.put(propertyName, newArray);
                
                //override or warnings accept passing through headers
                
                if(propertyName.equalsIgnoreCase("override") || propertyName.equalsIgnoreCase("warnings")){
                    parentJsonObj.put(propertyName, newObject) ;
                }
                
                return Optional.of(newObject);
            }

            Optional.empty();
        }
        return parent;

    }

    public static void checkValidJsonIndex(@SuppressWarnings("rawtypes") Optional optional, int index,
            boolean createChild, String propertyName) {
        if (optional.isPresent() && optional.get() instanceof JSONObject) {
            // While creating child, check if the index is not greater than 1
            if (createChild && index > 1) {
                THROW_INVALID_PATH_EXCEPTION.accept(index, propertyName);
            }
        }

        if (optional.isPresent() && optional.get() instanceof JSONArray) {
            // While creating child, check if the index is not greater than the
            // array length by 1
            JSONArray jsonArray = (JSONArray) optional.get();
            if (createChild && index > jsonArray.length()) {
                THROW_INVALID_PATH_EXCEPTION.accept(index, propertyName);
            }
        }
    }
//Run Single service
    
    public static String execueCMD(long timeoutSec, String cmd, String path) throws Exception {

          String line = "";
          Process process;

          String op = "OP=";
//Here, we have to run ofs to make the status field to start
          
          boolean executionStatus = false;
          try {
            
              process = new ProcessBuilder("cmd.exe", "/c", cmd).directory(new File(path)).start();

              process.getOutputStream().close();
              process.waitFor(timeoutSec, TimeUnit.SECONDS);
              process.destroy(); // tell the process to stop
              process.waitFor(10, TimeUnit.SECONDS); // give it a chance to stop
              process.destroyForcibly(); // tell the OS to kill the process
              process.waitFor();
              BufferedReader stdInput = new BufferedReader(new InputStreamReader(process.getInputStream()));
              BufferedReader stdError = new BufferedReader(new InputStreamReader(process.getErrorStream()));
              System.out.println("Here is the standard output of the command:\n");

              while (stdInput.ready() && (line = stdInput.readLine()) != null) {

                  // while ((line = stdInput.readLine()) != null) {
                  System.out.println(line);
                  op = op + line;
                  executionStatus = true;
              }
              System.out.println("Here is the standard error of the command (if any):\n");
              // while ((line = stdError.readLine()) != null) {
              while (stdError.ready() && (line = stdError.readLine()) != null) {

                  op = op + line;
                  // System.out.println("====== Ananth T Failure Cases =======");
                  System.out.println(line);
                  executionStatus = false;
              }
          } catch (IOException e) {
              // TODO Auto-generated catch block
              e.printStackTrace();
              op = line + Throwables.getStackTraceAsString(e);
          }
          return op + ":=" + String.valueOf(executionStatus);
      }
    
    //Execute OFS message with auto generated record id
    public static  String ExecuteOfsMessageWithId(String RecrdId, String ofsMsgWithId) {

        //String[] passWords = ofsMsgData.split("@", 2);
        System.out.println(ofsMsgWithId);
        System.out.println(RecrdId);
       String ofsMsgData = ofsMsgWithId.replace("RECID", RecrdId).replace("CUS123","CUS" + RecrdId );
       System.out.println(ofsMsgData);
        
        //String T24_APPSERVER_URL = "http://localhost:9089";
        try {
            String userAgent = ofsMsgData.split(",")[2].split("/")[0]; 
            String passWord = ofsMsgData.split(",")[2].split("/")[1];
            System.out.println(userAgent);
            System.out.println(passWord);

            if (T24_APPSERVER_URL.endsWith("/")) {
                T24_APPSERVER_URL = T24_APPSERVER_URL.substring(0, T24_APPSERVER_URL.length() - 1);
            }
            String servicePointUrlUpdated = T24_APPSERVER_URL + "/axis2/services/OFSConnectorServiceWS.OFSConnectorServiceWSHttpSoap11Endpoint";

            System.out.println("UPDATED URL:::" + servicePointUrlUpdated);

            URL obj = new URL(servicePointUrlUpdated);
            HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();
            postConnection.setConnectTimeout(100000);
            postConnection.setReadTimeout(100000);
            postConnection.setRequestMethod("POST");
            // postConnection.setRequestProperty("User-Agent", userAgent);
            //   postConnection.setRequestProperty("password", passWord);
            postConnection.setRequestProperty("Content-Type", "text/xml; charset=utf-8");


            postConnection.setDoOutput(true);

            StringBuffer ofsXmlMessage = new StringBuffer();

            ofsXmlMessage.append("<?xml version='1.0' encoding='utf-8'?>\n");
            ofsXmlMessage.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ofs=\"http://OFSConnectorServiceWS\" xmlns:xsd=\"http://data.services.soa.temenos.com/xsd\">\n");
            ofsXmlMessage.append("        <soapenv:Header/>\n");
            ofsXmlMessage.append("        <soapenv:Body>\n");
            ofsXmlMessage.append("                <ofs:processOFS>\n");
            ofsXmlMessage.append("                        <ofs:userDetails>\n");
            ofsXmlMessage.append("                                <xsd:user>" + userAgent + "</xsd:user>\n");
            ofsXmlMessage.append("                                <xsd:password>" + passWord + "</xsd:password>\n");
            ofsXmlMessage.append("                        </ofs:userDetails>\n");
            ofsXmlMessage.append("                        <ofs:ofsRequest>" + ofsMsgData + "</ofs:ofsRequest>\n");
            ofsXmlMessage.append("                </ofs:processOFS>\n");
            ofsXmlMessage.append("        </soapenv:Body>\n");
            ofsXmlMessage.append("</soapenv:Envelope>");

            /*System.out.print(ofsXmlMessage + "\n");*/

            DataOutputStream os = new DataOutputStream(postConnection.getOutputStream());
            os.writeBytes(ofsXmlMessage.toString());
            os.flush();
            os.close();
            //System.out.println("XML PAYLOAD"+ofsXmlMessage.toString());
            int responseCode = postConnection.getResponseCode();
           System.out.println("POST Response Code :  " + responseCode);
           System.out.println("POST Response Message : " + postConnection.getResponseMessage());

            if (responseCode == HttpURLConnection.HTTP_CREATED ||
                    responseCode == HttpURLConnection.HTTP_OK) { //success
                BufferedReader in = new BufferedReader(new InputStreamReader(
                        postConnection.getInputStream()));
                String inputLine;
                StringBuffer data = new StringBuffer();
                while ((inputLine = in.readLine()) != null) {
                    data.append(inputLine);
                }
                in.close();
                // print result
                System.out.println("DATA:" + data.toString());

                /*String responseContent = response.substring(response.indexOf("<ax219:ofsResponse>")+ "<ax219:ofsResponse>".length(), response.indexOf("</ax219:ofsResponse>"));*/

                /*String responseContent = response.substring(response.indexOf("ofsResponse>")+ "ofsResponse>".length(), response.indexOf("ofsResponse>"));*/

                String responseContent = data.substring(data.indexOf("ofsResponse>") + "ofsResponse>".length());
                responseContent = responseContent.substring(0, responseContent.indexOf("ofsResponse>"));

                responseContent = responseContent.substring(0, responseContent.lastIndexOf("</"));

                if (responseContent.contains("&lt;")) {
                    responseContent = responseContent.replaceAll("&lt;", "<");
                }
                System.out.println("ARRAYSLIST" + Arrays.asList(responseContent));
           
                
              
                return responseContent;

            } else {
                return "//-1//HTTP CONNECTION ISSUE TO THE SPECIFIED ENDPOINT";


            }
        } catch (Exception e) {
            e.printStackTrace();
            return "//-1//"+ Throwables.getStackTraceAsString(e);
        }

     }
    
    
    //Execute OFS message
    public static String ExecuteOfsMessage(String ofsMsgData) {


         //String T24_APPSERVER_URL = Environment.getEnvironmentVariable("T24_APPSERVER_URL", "") ;
        //String T24_APPSERVER_URL = "http://localhost:9089" ;
        try {
            String userAgent = ofsMsgData.split(",")[2].split("/")[0];
            String passWord = ofsMsgData.split(",")[2].split("/")[1];
            System.out.println(userAgent);
            System.out.println(passWord);
            Random random = new Random();
            //String ofsMsgDataWithMnemonic = ofsMsgData.replace("RECID", RecrdId);
            if (T24_APPSERVER_URL.endsWith("/")) {
                T24_APPSERVER_URL = T24_APPSERVER_URL.substring(0, T24_APPSERVER_URL.length() - 1);
            }
            String servicePointUrlUpdated = T24_APPSERVER_URL + "/axis2/services/OFSConnectorServiceWS.OFSConnectorServiceWSHttpSoap11Endpoint";

            System.out.println("UPDATED URL:::" + servicePointUrlUpdated);

            URL obj = new URL(servicePointUrlUpdated);
            HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();
            postConnection.setConnectTimeout(300000);
            postConnection.setReadTimeout(300000);
            postConnection.setRequestMethod("POST");
            // postConnection.setRequestProperty("User-Agent", userAgent);
            //   postConnection.setRequestProperty("password", passWord);
            postConnection.setRequestProperty("Content-Type", "text/xml; charset=utf-8");


            postConnection.setDoOutput(true);

            StringBuffer ofsXmlMessage = new StringBuffer();

            ofsXmlMessage.append("<?xml version='1.0' encoding='utf-8'?>\n");
            ofsXmlMessage.append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ofs=\"http://OFSConnectorServiceWS\" xmlns:xsd=\"http://data.services.soa.temenos.com/xsd\">\n");
            ofsXmlMessage.append("        <soapenv:Header/>\n");
            ofsXmlMessage.append("        <soapenv:Body>\n");
            ofsXmlMessage.append("                <ofs:processOFS>\n");
            ofsXmlMessage.append("                        <ofs:userDetails>\n");
            ofsXmlMessage.append("                                <xsd:user>" + userAgent + "</xsd:user>\n");
            ofsXmlMessage.append("                                <xsd:password>" + passWord + "</xsd:password>\n");
            ofsXmlMessage.append("                        </ofs:userDetails>\n");
            ofsXmlMessage.append("                        <ofs:ofsRequest>" + ofsMsgData + "</ofs:ofsRequest>\n");
            ofsXmlMessage.append("                </ofs:processOFS>\n");
            ofsXmlMessage.append("        </soapenv:Body>\n");
            ofsXmlMessage.append("</soapenv:Envelope>");

            /*System.out.print(ofsXmlMessage + "\n");*/

            DataOutputStream os = new DataOutputStream(postConnection.getOutputStream());
            os.writeBytes(ofsXmlMessage.toString());
            os.flush();
            os.close();
            //System.out.println("XML PAYLOAD"+ofsXmlMessage.toString());
            int responseCode = postConnection.getResponseCode();
           System.out.println("POST Response Code :  " + responseCode);
           System.out.println("POST Response Message : " + postConnection.getResponseMessage());

            if (responseCode == HttpURLConnection.HTTP_CREATED ||
                    responseCode == HttpURLConnection.HTTP_OK) { //success
                BufferedReader in = new BufferedReader(new InputStreamReader(
                        postConnection.getInputStream()));
                String inputLine;
                StringBuffer data = new StringBuffer();
                while ((inputLine = in.readLine()) != null) {
                    data.append(inputLine);
                }
                in.close();
                // print result
                System.out.println("DATA:" + data.toString());

                /*String responseContent = response.substring(response.indexOf("<ax219:ofsResponse>")+ "<ax219:ofsResponse>".length(), response.indexOf("</ax219:ofsResponse>"));*/

                /*String responseContent = response.substring(response.indexOf("ofsResponse>")+ "ofsResponse>".length(), response.indexOf("ofsResponse>"));*/

                String responseContent = data.substring(data.indexOf("ofsResponse>") + "ofsResponse>".length());
                responseContent = responseContent.substring(0, responseContent.indexOf("ofsResponse>"));

                responseContent = responseContent.substring(0, responseContent.lastIndexOf("</"));

                if (responseContent.contains("&lt;")) {
                    responseContent = responseContent.replaceAll("&lt;", "<");
                }
                System.out.println("ARRAYSLIST" + Arrays.asList(responseContent));
//                idFromResponseContents = responseContent.split("/")[0];
//                
//                System.out.println("Id in OFS is" + idFromResponseContents);
                
                return responseContent;

            } else {
                return "//-1//HTTP CONNECTION ISSUE TO THE SPECIFIED ENDPOINT";


            }
        } catch (Exception e) {
            e.printStackTrace();
            return "//-1//"+ Throwables.getStackTraceAsString(e);
        }

     }
    
    public void setBundleWithSessionLinkAttribute(String bundleId, String propertyKey) {
        cucumberInteractionSession.scenarioBundle().put(bundleId,
                cucumberInteractionSession.entities().item().get(propertyKey));
    } 
    
//    public static void JsonToBinary(String jsonFilePath, String inboxTopic, String index) throws Exception
//    {
//        
//        StreamProducer<byte[]> producer = createStreamProducer("itest", "kafka");
//        String content = new String(Files.readAllBytes(Paths.get(jsonFilePath)));
//        producer.batch().add(inboxTopic, index,
//                new String(content).getBytes());
//        try {
//            producer.batch().send();
//        } catch (StreamProducerException | InterruptedException e) {
//            e.printStackTrace();
//        }
//    }
    
////    private static StreamProducer<byte[]> createStreamProducer(String producerName, String streamVendor) {
////        if ("kinesis".equals(streamVendor)) {
////            return new KinesisStreamProducer.Builder().setAggregationEnabled(true).setKinesisPort(443)
////                    .setRegionName(Environment.getAwsRegion().getName()).producer();
////        } else {
////            String producerClientId = producerName != null && !producerName.isEmpty() ? producerName : "test-producer";
////            Properties props = new Properties();
////            props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG,
////                    Environment.getEnvironmentVariable(IngesterConfigProperty.STREAM_KAFKA_BOOTSTRAP_SERVERS.getName(),
////                            DEFAULT_STREAM_KAFKA_BOOTSTRAP_SERVERS));
////            if ("true".equals(Environment
////                    .getEnvironmentVariable(IngesterConfigProperty.STREAM_KAFKA_SASL_ENABLED.getName(), "false"))) {
////                props.put(CommonClientConfigs.SECURITY_PROTOCOL_CONFIG, Environment.getEnvironmentVariable(
////                        IngesterConfigProperty.STREAM_KAFKA_SECURITY_PROTOCOL.getName(), "SASL_SSL"));
////                props.put(SaslConfigs.SASL_MECHANISM, Environment
////                        .getEnvironmentVariable(IngesterConfigProperty.STREAM_KAFKA_SASL_MECHANISM.getName(), "PLAIN"));
////                props.put(SaslConfigs.SASL_JAAS_CONFIG, Environment.getEnvironmentVariable(
////                        IngesterConfigProperty.STREAM_KAFKA_SASL_JAAS_CONFIG.getName(),"org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"Endpoint=sb://des-topics.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=dUu03/v8U/mTWOu9LxhqYC4wzX+sb3G6/R/nwMnQmi0=\";"));
////            }
////            props.put(ProducerConfig.ACKS_CONFIG, "all");
////            props.put(ProducerConfig.ENABLE_IDEMPOTENCE_CONFIG, true);
////            props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
////            props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, ByteArraySerializer.class);
////            props.put(ProducerConfig.BATCH_SIZE_CONFIG, 16384);
////            props.put(ProducerConfig.LINGER_MS_CONFIG, 1);
////            props.put(ProducerConfig.BUFFER_MEMORY_CONFIG, 33554432);
////            return new KafkaStreamProducer.Builder().setProperties(props).setClientId(producerClientId)
////                    .setTransactional(false).producer();
////        }
//    }
    
    }

    


