package com.temenos.microservice.cucumber.t24datastepdefinitions;

import static java.text.MessageFormat.format;

import java.io.IOException;

import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;

import com.temenos.useragent.cucumber.config.StepDefinitionConfiguration;
import com.temenos.useragent.cucumber.steps.CucumberInteractionSession;
import com.temenos.useragent.generic.internal.DefaultEntityWrapper;
import com.temenos.useragent.generic.internal.EntityHandler;
import com.temenos.useragent.generic.internal.EntityWrapper;
import com.temenos.useragent.generic.mediatype.PlainTextEntityHandler;

import cucumber.api.java8.En;

/**
 * Process Payload Input Json
 *
 * @author mohamedasarudeen
 *
 */
public class StepDefinitionForInputJsonPayload implements En {
    @Autowired
    private CucumberInteractionSession cucumberInteractionSession;
    
    private JSONObject json;
    
    private JSONArray jsonArray;

    public StepDefinitionForInputJsonPayload(StepDefinitionConfiguration stepConfig) {
      
        Given("^(?:I ?)*I Initialize Json Payload$", () -> {
            json = new JSONObject();
            this.setJson(json);
        });

        Given(format("^(?:I ?)*set property {0} from bundle value {0}$", stepConfig.stringRegEx()),
                (String propertyName, String bundlevariablename) -> {
                   String id =cucumberInteractionSession.scenarioBundle().getString(bundlevariablename.replace("{", "").replace("}", ""));
                    this.getJson().put(propertyName, id);
                });
        Given(format("^(?:I ?)*set property {0} with json value {0} append with unique value {0}$", stepConfig.stringRegEx()),
                (String propertyName,String propertyValue, String bundlevariablename) -> {
                   String id =cucumberInteractionSession.scenarioBundle().getString(bundlevariablename.replace("{", "").replace("}", ""));
                   String uniqueValue= propertyValue.concat(id);
                    this.getJson().put(propertyName, uniqueValue);
                }); 
            
        Given(format("^(?:I ?)*set property {0} from bundle array value {0}$", stepConfig.stringRegEx()),
                (String propertyName, String bundlevariablename) -> {
                   String id =cucumberInteractionSession.scenarioBundle().getString(bundlevariablename.replace("{", "").replace("}", ""));
                   jsonArray = new JSONArray();
                   this.getJsonArray().put(new JSONObject().put(propertyName, id));
                });
        

        Given("^(?:I ?)*I Initialize JsonArray$", () -> {
            jsonArray = new JSONArray();
            this.setJsonArray(jsonArray);
        });
        
        Given(format("^(?:I ?)*set property {0} into Json Array with value {0}$", stepConfig.stringRegEx()),
        (String propertyName, String propertyValue) -> {
            this.getJsonArray().put(new JSONObject().put(propertyName, propertyValue));
        });
        
        
        Given(format("^(?:I ?)*set property {0} into Json Array with value {0} append with unique value {0}$", stepConfig.stringRegEx()),
                (String propertyName,String propertyValue, String bundlevariablename) -> {
                   String id =cucumberInteractionSession.scenarioBundle().getString(bundlevariablename.replace("{", "").replace("}", ""));
                   String uniqueValue= propertyValue.concat(id);
                   this.getJsonArray().put(new JSONObject().put(propertyName, uniqueValue));
                }); 
        
        
        Given(format("^(?:I ?)*I add this JsonArray into the Json Object with a name {0}$" , stepConfig.stringRegEx()),
                (String propertyName) -> {
                   this.getJson().put(propertyName, this.getJsonArray());
                });
        
         Given(format("^(?:I ?)*I set property {0} with json value {0}$", stepConfig.stringRegEx()),
                (String propertyName, String propertyValue) -> {
                    System.out.println(propertyName);
                    this.getJson().put(propertyName, propertyValue)    ;               
                }); 
                
         Given(format("^(?:I ?)*I post to {0} with arguments$", stepConfig.stringRegEx()),
                (String fileName) -> {
                    
                    generateInputwithJson(fileName, this.getJson());                   
                });              
    }
    
    
    public void generateInputwithJson(String fileName,JSONObject jsonPayload) {       
        cucumberInteractionSession.use(setRequestPayloadAtRuntime(fileName, jsonPayload));   
    }
  
    private EntityWrapper setRequestPayloadAtRuntime(String fileName ,JSONObject jsonProperties) {
        String payload = "";

        try {
            payload = IOUtils.toString(getClass().getClassLoader().getResourceAsStream(fileName));
        } catch (IOException e) {
            e.printStackTrace();
        }
        JSONObject json = new JSONObject(payload);
        json.put("body", jsonProperties);
        EntityHandler handler = new PlainTextEntityHandler(json.toString());
        EntityWrapper entity = new DefaultEntityWrapper();
        entity.setHandler(handler);
        return entity;
    }

    /**
     * @return the json
     */
    public JSONObject getJson() {
        return json;
    }


    /**
     * @param json the json to set
     */
    public void setJson(JSONObject json) {
        this.json = json;
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
