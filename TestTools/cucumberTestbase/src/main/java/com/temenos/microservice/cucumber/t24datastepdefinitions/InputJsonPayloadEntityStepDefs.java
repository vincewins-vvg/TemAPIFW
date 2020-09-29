package com.temenos.microservice.cucumber.t24datastepdefinitions;

import static java.text.MessageFormat.format;
import static java.util.Optional.ofNullable;
import static org.junit.Assert.assertNotNull;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;

import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;

import com.temenos.useragent.cucumber.config.StepDefinitionConfiguration;
import com.temenos.useragent.cucumber.steps.CucumberInteractionSession;
import com.temenos.useragent.generic.Entity;
import com.temenos.useragent.generic.internal.DefaultEntityWrapper;
import com.temenos.useragent.generic.internal.EntityHandler;
import com.temenos.useragent.generic.internal.EntityWrapper;
import com.temenos.useragent.generic.mediatype.PlainTextEntityHandler;
import com.temenos.useragent.generic.mediatype.PropertyNameUtil;

import cucumber.api.java8.En;

/**
 * To construct the Payload Json Request Input
 *
 * @author mohamedasarudeen
 *
 */
public class InputJsonPayloadEntityStepDefs implements En {
    @Autowired
    private CucumberInteractionSession cucumberInteractionSession;

    private JSONObject json;
    private JSONObject json1;

    private JSONArray jsonArray;
    private HashMap<String, JSONArray> jsonArrayMap;

    private JSONObject bodyObject;
    private JSONObject headerObject;

    public InputJsonPayloadEntityStepDefs(StepDefinitionConfiguration stepConfig) {

        Given("^(?:I ?)*I Initialize Json Object Payload$", () -> {
            bodyObject = new JSONObject();
            headerObject = new JSONObject();
        });
        
        
        Given(format("^(?:I ?)*Accept the overrides or warnings and {0} the request$", stepConfig.stringRegEx()),
                (String httpMethod) -> {
                    if (cucumberInteractionSession.result().code() == 400){
                        
                        if(cucumberInteractionSession.entities().item().get("override") != null){
                            cucumberInteractionSession.reuse();
                        Entity requestEntity = cucumberInteractionSession.entities().item();
                        String overrideHeader= requestEntity.get("header");
                        JSONObject override_header_obj = new JSONObject(overrideHeader);
                        String override = cucumberInteractionSession.entities().item().get("override");
                        JSONObject obje = new JSONObject(override);
                        JSONArray overrideArray = obje.getJSONArray("overrideDetails");
                        
                        for (Object object : overrideArray) {
                            if ( object instanceof JSONObject ) {
                                ((JSONObject) object).put("responseCode", "YES");
                             }
                        }
                        obje.put("overrideDetails", overrideArray);
                        override_header_obj.put("override", obje);
                        cucumberInteractionSession.use(setRequestPayloadWithOverride(bodyObject, override_header_obj));
                        cucumberInteractionSession.executeRequest(httpMethod);
                        }
                    }
                   

                });

        Given(format("^(?:I ?)*set json payload body value {0} for property path {0}$", stepConfig.stringRegEx()),
                (String value, String path) -> {

                    final List<String> pathParts = Arrays.asList(JsonUtil.flattenPropertyName(path));
                    final Optional<JSONObject> parent = JsonUtil.navigateJsonObjectforPropertyPath(
                            ofNullable(bodyObject), pathParts.subList(0, pathParts.size() - 1), path, true);
                    if (parent.isPresent()) {
                        parent.get().put(pathParts.get(pathParts.size() - 1), value);
                    }

                });

        Given(format("^(?:I ?)*set json payload header value {0} for property path {0}$", stepConfig.stringRegEx()),
                (String value, String path) -> {

                    final List<String> pathParts = Arrays.asList(JsonUtil.flattenPropertyName(path));
                    final Optional<JSONObject> parent = JsonUtil.navigateJsonObjectforPropertyPath(
                            ofNullable(headerObject), pathParts.subList(0, pathParts.size() - 1), path, true);
                    if (parent.isPresent()) {
                        parent.get().put(pathParts.get(pathParts.size() - 1), value);
                    }
                });
        
        // bundle set - unique id and account or customer id set from session
        
        Given(format("^(?:I ?)*set json payload body bundle value {0} for property path {0}$", stepConfig.stringRegEx()),
                (String bundlevariablename, String path) -> {

                    String id =cucumberInteractionSession.scenarioBundle().getString(bundlevariablename.replace("{", "").replace("}", ""));
                    
                    final List<String> pathParts = Arrays.asList(JsonUtil.flattenPropertyName(path));
                    final Optional<JSONObject> parent = JsonUtil.navigateJsonObjectforPropertyPath(
                            ofNullable(bodyObject), pathParts.subList(0, pathParts.size() - 1), path, true);
                    if (parent.isPresent()) {
                        parent.get().put(pathParts.get(pathParts.size() - 1), id);
                    }

                });
        
        Given(format("^(?:I ?)*set json payload header bundle value {0} for property path {0}$", stepConfig.stringRegEx()),
                (String bundlevariablename, String path) -> {

                    String id =cucumberInteractionSession.scenarioBundle().getString(bundlevariablename.replace("{", "").replace("}", ""));
                    
                    final List<String> pathParts = Arrays.asList(JsonUtil.flattenPropertyName(path));
                    final Optional<JSONObject> parent = JsonUtil.navigateJsonObjectforPropertyPath(
                            ofNullable(headerObject), pathParts.subList(0, pathParts.size() - 1), path, true);
                    if (parent.isPresent()) {
                        parent.get().put(pathParts.get(pathParts.size() - 1), id);
                    }

                });
        
        Given(format("^(?:I ?)*set json payload body bundle value {0} append with unique value {0} for property path {0}$", stepConfig.stringRegEx()),
                (String value, String bundlevariablename, String path) -> {

                    String id =cucumberInteractionSession.scenarioBundle().getString(bundlevariablename.replace("{", "").replace("}", ""));
                    String uniqueValue= value.concat(id);
                    
                    final List<String> pathParts = Arrays.asList(JsonUtil.flattenPropertyName(path));
                    final Optional<JSONObject> parent = JsonUtil.navigateJsonObjectforPropertyPath(
                            ofNullable(bodyObject), pathParts.subList(0, pathParts.size() - 1), path, true);
                    if (parent.isPresent()) {
                        parent.get().put(pathParts.get(pathParts.size() - 1), uniqueValue);
                    }

                });
        
        Given(format("^(?:I ?)*set json payload body bundle value {0} appended with value {0} for property path {0}$", stepConfig.stringRegEx()),
                (String bundleKey, String value, String path) -> {
                    
                    String bundleValue = cucumberInteractionSession.scenarioBundle().getString(bundleKey);
                    assertNotNull(bundleValue);
                    
                    final List<String> pathParts = Arrays.asList(JsonUtil.flattenPropertyName(path));
                    final Optional<JSONObject> parent = JsonUtil.navigateJsonObjectforPropertyPath(
                            ofNullable(bodyObject), pathParts.subList(0, pathParts.size() - 1), path, true);
                    if (parent.isPresent()) {
                        parent.get().put(pathParts.get(pathParts.size() - 1), bundleValue.concat(value));
                    }

                });
        
        Given(format("^(?:I ?)*set json payload header bundle value {0} appended with value {0} for property path {0}$", stepConfig.stringRegEx()),
                (String bundleKey, String value, String path) -> {
                    
                    String bundleValue = cucumberInteractionSession.scenarioBundle().getString(bundleKey);
                    assertNotNull(bundleValue);
                    
                    final List<String> pathParts = Arrays.asList(JsonUtil.flattenPropertyName(path));
                    final Optional<JSONObject> parent = JsonUtil.navigateJsonObjectforPropertyPath(
                            ofNullable(headerObject), pathParts.subList(0, pathParts.size() - 1), path, true);
                    if (parent.isPresent()) {
                        parent.get().put(pathParts.get(pathParts.size() - 1), bundleValue.concat(value));
                    }

                });
        
        
        Given(format("^(?:I ?)*set json payload body bundle value {0} appended between values {0} and {0} for property path {0}$", stepConfig.stringRegEx()),
                (String bundleKey, String value1, String value2, String path) -> {
                    
                    String bundleValue = cucumberInteractionSession.scenarioBundle().getString(bundleKey);
                    assertNotNull(bundleValue);
                    
                    final List<String> pathParts = Arrays.asList(JsonUtil.flattenPropertyName(path));
                    final Optional<JSONObject> parent = JsonUtil.navigateJsonObjectforPropertyPath(
                            ofNullable(bodyObject), pathParts.subList(0, pathParts.size() - 1), path, true);
                    if (parent.isPresent()) {
                        parent.get().put(pathParts.get(pathParts.size() - 1), value1+bundleValue+value2);
                    }

 

                });
        
        Given(format("^(?:I ?)*set json payload header bundle value {0} append with unique value {0} for property path {0}$", stepConfig.stringRegEx()),
                (String value, String bundlevariablename, String path) -> {

                    String id =cucumberInteractionSession.scenarioBundle().getString(bundlevariablename.replace("{", "").replace("}", ""));
                    String uniqueValue= value.concat(id);
                    
                    final List<String> pathParts = Arrays.asList(JsonUtil.flattenPropertyName(path));
                    final Optional<JSONObject> parent = JsonUtil.navigateJsonObjectforPropertyPath(
                            ofNullable(headerObject), pathParts.subList(0, pathParts.size() - 1), path, true);
                    if (parent.isPresent()) {
                        parent.get().put(pathParts.get(pathParts.size() - 1), uniqueValue);
                    }

                });
        
        //**************** Set Json Object from User Agent Generic Library******************
        
        Given(format("^(?:I ?)*set json payload body Useragent Json Object value {0} for property path {0}$", stepConfig.stringRegEx()),
                (String value, String path) -> {

                    final List<String> pathParts = Arrays.asList(PropertyNameUtil.flattenPropertyName(path));
                    final Optional<JSONObject> parent = com.temenos.useragent.generic.mediatype.JsonUtil.navigateJsonObjectforPropertyPath(
                            ofNullable(bodyObject), pathParts.subList(0, pathParts.size() - 1), path, true);
                    if (parent.isPresent()) {
                        parent.get().put(pathParts.get(pathParts.size() - 1), value);
                    }

                });

        Given(format("^(?:I ?)*set json payload header Useragent Json Object value {0} for property path {0}$", stepConfig.stringRegEx()),
                (String value, String path) -> {

                    final List<String> pathParts = Arrays.asList(PropertyNameUtil.flattenPropertyName(path));
                    final Optional<JSONObject> parent = com.temenos.useragent.generic.mediatype.JsonUtil.navigateJsonObjectforPropertyPath(
                            ofNullable(headerObject), pathParts.subList(0, pathParts.size() - 1), path, true);
                    if (parent.isPresent()) {
                        parent.get().put(pathParts.get(pathParts.size() - 1), value);
                    }
                });
        
        // bundle set - unique id and account or customer id set from session
        
        Given(format("^(?:I ?)*set json payload body Useragent Json Object bundle value {0} for property path {0}$", stepConfig.stringRegEx()),
                (String bundlevariablename, String path) -> {

                    String id =cucumberInteractionSession.scenarioBundle().getString(bundlevariablename.replace("{", "").replace("}", ""));
                    
                    final List<String> pathParts = Arrays.asList(PropertyNameUtil.flattenPropertyName(path));
                    final Optional<JSONObject> parent = com.temenos.useragent.generic.mediatype.JsonUtil.navigateJsonObjectforPropertyPath(
                            ofNullable(bodyObject), pathParts.subList(0, pathParts.size() - 1), path, true);
                    if (parent.isPresent()) {
                        parent.get().put(pathParts.get(pathParts.size() - 1), id);
                    }

                });
        
        Given(format("^(?:I ?)*set json payload header Useragent Json Object bundle value {0} for property path {0}$", stepConfig.stringRegEx()),
                (String bundlevariablename, String path) -> {

                    String id =cucumberInteractionSession.scenarioBundle().getString(bundlevariablename.replace("{", "").replace("}", ""));
                    
                    final List<String> pathParts = Arrays.asList(PropertyNameUtil.flattenPropertyName(path));
                    final Optional<JSONObject> parent = com.temenos.useragent.generic.mediatype.JsonUtil.navigateJsonObjectforPropertyPath(
                            ofNullable(headerObject), pathParts.subList(0, pathParts.size() - 1), path, true);
                    if (parent.isPresent()) {
                        parent.get().put(pathParts.get(pathParts.size() - 1), id);
                    }

                });
        
        Given(format("^(?:I ?)*set json payload body Useragent Json Object bundle value {0} append with unique value {0} for property path {0}$", stepConfig.stringRegEx()),
                (String value, String bundlevariablename, String path) -> {

                    String id =cucumberInteractionSession.scenarioBundle().getString(bundlevariablename.replace("{", "").replace("}", ""));
                    String uniqueValue= value.concat(id);
                    
                    final List<String> pathParts = Arrays.asList(PropertyNameUtil.flattenPropertyName(path));
                    final Optional<JSONObject> parent = com.temenos.useragent.generic.mediatype.JsonUtil.navigateJsonObjectforPropertyPath(
                            ofNullable(bodyObject), pathParts.subList(0, pathParts.size() - 1), path, true);
                    if (parent.isPresent()) {
                        parent.get().put(pathParts.get(pathParts.size() - 1), uniqueValue);
                    }

                });
        
        Given(format("^(?:I ?)*set json payload body Useragent Json Object bundle value {0} appended with value {0} for property path {0}$", stepConfig.stringRegEx()),
                (String bundleKey, String value, String path) -> {
                    
                    String bundleValue = cucumberInteractionSession.scenarioBundle().getString(bundleKey);
                    assertNotNull(bundleValue);
                    
                    final List<String> pathParts = Arrays.asList(PropertyNameUtil.flattenPropertyName(path));
                    final Optional<JSONObject> parent = com.temenos.useragent.generic.mediatype.JsonUtil.navigateJsonObjectforPropertyPath(
                            ofNullable(bodyObject), pathParts.subList(0, pathParts.size() - 1), path, true);
                    if (parent.isPresent()) {
                        parent.get().put(pathParts.get(pathParts.size() - 1), bundleValue.concat(value));
                    }

                });
        
        Given(format("^(?:I ?)*set json payload header Useragent Json Object bundle value {0} appended with value {0} for property path {0}$", stepConfig.stringRegEx()),
                (String bundleKey, String value, String path) -> {
                    
                    String bundleValue = cucumberInteractionSession.scenarioBundle().getString(bundleKey);
                    assertNotNull(bundleValue);
                    
                    final List<String> pathParts = Arrays.asList(PropertyNameUtil.flattenPropertyName(path));
                    final Optional<JSONObject> parent = com.temenos.useragent.generic.mediatype.JsonUtil.navigateJsonObjectforPropertyPath(
                            ofNullable(headerObject), pathParts.subList(0, pathParts.size() - 1), path, true);
                    if (parent.isPresent()) {
                        parent.get().put(pathParts.get(pathParts.size() - 1), bundleValue.concat(value));
                    }

                });
        
        Given(format("^(?:I ?)*set json payload header Useragent Json Object bundle value {0} append with unique value {0} for property path {0}$", stepConfig.stringRegEx()),
                (String value, String bundlevariablename, String path) -> {

                    String id =cucumberInteractionSession.scenarioBundle().getString(bundlevariablename.replace("{", "").replace("}", ""));
                    String uniqueValue= value.concat(id);
                    
                    final List<String> pathParts = Arrays.asList(PropertyNameUtil.flattenPropertyName(path));
                    final Optional<JSONObject> parent = com.temenos.useragent.generic.mediatype.JsonUtil.navigateJsonObjectforPropertyPath(
                            ofNullable(headerObject), pathParts.subList(0, pathParts.size() - 1), path, true);
                    if (parent.isPresent()) {
                        parent.get().put(pathParts.get(pathParts.size() - 1), uniqueValue);
                    }

                });
        
        
        //END ************** Set  JSon object from Useragent Generic*****************
                
                 
         Given(format("^(?:I ?)*I post to {0} with arguments for json header and body payload$",
                stepConfig.stringRegEx()), (String fileName) -> {

                    generateInputwithJson(fileName, this.getJson(), this.getJson1());
                });
         
         Given(format("^(?:I ?)*I post to {0} for body payload$",
                 stepConfig.stringRegEx()), (String fileName) -> {

                     generateInputwithOnlyJson(fileName, this.getJson());
                 });
         
         Given(format("^(?:I ?)*I post to {0} with arguments for json header and body array object payload$",
                 stepConfig.stringRegEx()), (String fileName) -> {

                     generateInputwithJsonBodyArray(fileName, this.getJson(), this.getJson1());
                 });
    }

    public void generateInputwithJson(String fileName, JSONObject bodyJsonPayload, JSONObject headerJsonPayload) {
        cucumberInteractionSession.use(setRequestPayloadAtRuntime(fileName, bodyJsonPayload, headerJsonPayload));
    }
    
    public void generateInputwithOnlyJson(String fileName, JSONObject bodyJsonPayload) {
        cucumberInteractionSession.use(setRequestPayloadAtRuntimeWithoutHeader(fileName, bodyJsonPayload));
    }
    
    public void generateInputwithJsonBodyArray(String fileName, JSONObject bodyJsonPayload, JSONObject headerJsonPayload) {
        cucumberInteractionSession.use(setRequestPayloadAtRuntimeJsonBodyArray(fileName, bodyJsonPayload, headerJsonPayload));
    }

    private EntityWrapper setRequestPayloadAtRuntime(String fileName, JSONObject bodyjsonProperties,
            JSONObject headerjsonProperties) {
        String payload = "";

        try {
            payload = IOUtils.toString(getClass().getClassLoader().getResourceAsStream(fileName));
        } catch (IOException e) {
            e.printStackTrace();
        }
        JSONObject json = new JSONObject(payload);
        json.put("body", bodyjsonProperties);
        json.put("header", headerjsonProperties);
        EntityHandler handler = new PlainTextEntityHandler(json.toString());
        EntityWrapper entity = new DefaultEntityWrapper();
        entity.setHandler(handler);
        return entity;
    }
    
    private EntityWrapper setRequestPayloadAtRuntimeWithoutHeader(String fileName, JSONObject bodyjsonProperties) {
//        String payload = "";
//
//        try {
//            payload = IOUtils.toString(getClass().getClassLoader().getResourceAsStream(fileName));
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//        JSONObject json = new JSONObject(payload);
//        json.put("body", bodyjsonProperties);
//        //json.put("header", headerjsonProperties);
        EntityHandler handler = new PlainTextEntityHandler(bodyjsonProperties.toString());
        EntityWrapper entity = new DefaultEntityWrapper();
        entity.setHandler(handler);
        return entity;
    }
    
    private EntityWrapper setRequestPayloadAtRuntimeJsonBodyArray(String fileName, JSONObject bodyjsonProperties,
            JSONObject headerjsonProperties) {
        String payload = "";

        try {
            payload = IOUtils.toString(getClass().getClassLoader().getResourceAsStream(fileName));
        } catch (IOException e) {
            e.printStackTrace();
        }
        JSONObject json = new JSONObject(payload);        
        json.getJSONArray("body").put(bodyjsonProperties);       
        json.put("header", headerjsonProperties);
        EntityHandler handler = new PlainTextEntityHandler(json.toString());
        EntityWrapper entity = new DefaultEntityWrapper();
        entity.setHandler(handler);
        return entity;
    }
    
    private EntityWrapper setRequestPayloadWithOverride(JSONObject bodyjsonProperties,
            JSONObject headerjsonProperties) {

        JSONObject json = new JSONObject();
        json.put("body", bodyjsonProperties);
        json.put("header", headerjsonProperties);
        EntityHandler handler = new PlainTextEntityHandler(json.toString());
        EntityWrapper entity = new DefaultEntityWrapper();
        entity.setHandler(handler);
        return entity;
    }

    /**
     * @return the json
     */
    public JSONObject getJson() {
        return bodyObject;
    }

    /**
     * @param json
     *            the json to set
     */
    public void setJson(JSONObject json) {
        this.json = json;
    }

    /**
     * @return the json1
     */
    public JSONObject getJson1() {
        return headerObject;
    }

    /**
     * @param json1
     *            the json1 to set
     */
    public void setJson1(JSONObject json1) {
        this.json1 = json1;
    }

    /**
     * @return the jsonArray
     */
    public JSONArray getJsonArray() {
        return jsonArray;
    }

    /**
     * @param jsonArray the jsonArray to set
     */
    public void setJsonArray(JSONArray jsonArray) {
        this.jsonArray = jsonArray;
    }
}
