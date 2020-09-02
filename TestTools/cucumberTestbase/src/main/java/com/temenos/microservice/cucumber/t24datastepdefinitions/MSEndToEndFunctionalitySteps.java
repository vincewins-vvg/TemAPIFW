/*******************************************************************************
 * Copyright © Temenos Headquarters SA 2012-2018. All rights reserved.
 ******************************************************************************/
package com.temenos.microservice.cucumber.t24datastepdefinitions;

import static java.text.MessageFormat.format;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import com.temenos.microservice.test.cucumber.MSFrameworkEndPointConfiguration;
import com.temenos.useragent.cucumber.config.StepDefinitionConfiguration;
import com.temenos.useragent.cucumber.steps.CucumberInteractionSession;
import com.temenos.useragent.cucumber.steps.ScenarioBundleStepDefs;
import com.temenos.useragent.cucumber.utils.StringEvaluator;

import cucumber.api.java8.En;

/**
 * T24 Generic Action Step definition
 *
 * @author Vincent Vijay
 *
 */

public class MSEndToEndFunctionalitySteps implements En {
    
    @Autowired
    private CucumberInteractionSession cucumberInteractionSession;
    @Autowired
    private ScenarioBundleStepDefs scenarioBundleStepDefs;
    private MSFrameworkEndPointConfiguration endPointConfig;
    private String  idFromResponseContent;
    
    
    public static Map<String, String> DbcolumnValues = new HashMap<>(); // key - columnName, Value -
 
    private static final String METHOD_EXCEPTION_MSG = "Link method not available {0}. Exception: {1}";
        
    public MSEndToEndFunctionalitySteps(StepDefinitionConfiguration stepConfig, MSFrameworkEndPointConfiguration endPointConfig, StringEvaluator stringEvaluator) {
        
        
        
            this.endPointConfig = endPointConfig;
            
    And(format("^(?:I ?)*post an OFS Message and store record id in {0} and pass a bundle value in message {0} {0} {0}$", stepConfig.stringRegEx()),
                    (String recordIdKey , String ofsString1 ,String bundleValue, String ofsString2) -> { concatenateBundleValueInOFS(recordIdKey , ofsString1,  bundleValue,  ofsString2);
                    
                    });
    
    And(format("^(?:I ?)post an OFS Message and store record id in {0} and pass 2 bundle values in message {0} {0} {0} {0} {0}$", stepConfig.stringRegEx()),
            (String recordIdKey , String ofsString1 ,String bundleValue1, String ofsString2 , String bundleValue2 , String ofsString3) -> { concatenateBundleValueInOFS(recordIdKey , ofsString1,  bundleValue1,  ofsString2, bundleValue2 , ofsString3);
            
            });
    
    And(format("^(?:I ?)post an OFS Message and store record id in {0} and pass 3 bundle values in message {0} {0} {0} {0} {0} {0} {0}$", stepConfig.stringRegEx()),
            (String recordIdKey , String ofsString1 ,String bundleValue1, String ofsString2 , String bundleValue2 , String ofsString3, String bundleValue3, String ofsString4) -> { concatenateBundleValueInOFS(recordIdKey , ofsString1,  bundleValue1,  ofsString2, bundleValue2 , ofsString3, bundleValue3 ,ofsString4);
            
            });
    
    And(format("^(?:I ?)*post an OFS Message and store record id in {0} and value of field {0} in bundle {0} and pass a bundle value in message {0} {0} {0}$", stepConfig.stringRegEx()),
            (String recordIdKey ,String fieldName,String fieldValueBundle , String ofsString1 ,String bundleValue, String ofsString2) -> { concatenateBundleValueInOFSWithRecIdAndFieldValue(recordIdKey ,fieldName ,fieldValueBundle, ofsString1,  bundleValue,  ofsString2);
            
            });
    
    And(format("^(?:I ?)*post an OFS Message and store value of field {0} in bundle {0} in message {0}$", stepConfig.stringRegEx()),
            (String fieldName ,String bundleValue , String ofsString) -> { bundleOtherFieldValue(fieldName ,bundleValue , ofsString);
            
            });
    
    And(format("^(?:I ?)*post an OFS Message and store record id in {0} and value of field {0} in bundle {0} in message {0}$", stepConfig.stringRegEx()),
            (String recordIdKey, String fieldName ,String bundleValue , String ofsString) -> { bundleRecordIdAndOtherFieldValue(recordIdKey ,fieldName ,bundleValue , ofsString);
            
            });

    And(format("^(?:I ?)*post an OFS Message and value of field 1 {0} in bundle {0} and value of field 2 {0} in bundle {0} and pass a bundle value in message {0} {0} {0}$", stepConfig.stringRegEx()),
            (String fieldName1, String bundleValue1 ,String fieldName2 , String bundleValue2, String ofsString1, String ofsBundle, String ofsString2) -> { bundleOtherFieldValue(fieldName1 , bundleValue1, fieldName2 ,bundleValue2 , ofsString1 ,ofsBundle, ofsString2);
            
            });
    
} 
    
    public Object concatenateBundleValueInOFS(String recordIdGen , String ofsString1, String bundleValueInOFS,String ofsString2) {
        
           //To concatenate 1 bundle value with the ofs string
        
           String ofsString = ofsString1+cucumberInteractionSession.scenarioBundle().getString(bundleValueInOFS)+ofsString2;
           
           System.out.println("OFS String to be executed: "+ofsString);
           
           String responseContents= JsonUtil.ExecuteOfsMessage(ofsString);
           
           System.out.println("OFS response: "+responseContents);
           
          if (responseContents.startsWith("<requests><req"))
           {
               idFromResponseContent = responseContents.split(">")[2].split("/")[0];
           }
           else
           {
               idFromResponseContent = responseContents.split("/")[0];
           }
           
           //To get the record id from ofs response
           //String  idFromResponseContent = responseContents.split("/")[0];
        
        System.out.println("Record Id in OFS response is: " + idFromResponseContent);
        return cucumberInteractionSession.scenarioBundle().put(recordIdGen, idFromResponseContent);
    }
    
    
    public Object concatenateBundleValueInOFS(String recordIdGen , String ofsString1, String bundleValueInOFS1 ,String ofsString2, String bundleValueInOFS2, String ofsString3 ) {
        
        //To concatenate 2 bundle value with the ofs string
     
        String ofsString = ofsString1+cucumberInteractionSession.scenarioBundle().getString(bundleValueInOFS1)+ofsString2 + cucumberInteractionSession.scenarioBundle().getString(bundleValueInOFS2)+ofsString3;
        
        System.out.println("OFS String to be executed: "+ofsString);
        
        String responseContents= JsonUtil.ExecuteOfsMessage(ofsString);
        
        System.out.println("OFS response: "+responseContents);
        
        if (responseContents.startsWith("<requests><req"))
        {
            idFromResponseContent = responseContents.split(">")[2].split("/")[0];
        }
        else
        {
            idFromResponseContent = responseContents.split("/")[0];
        }
             
     System.out.println("Record Id in OFS response is: " + idFromResponseContent);
     return cucumberInteractionSession.scenarioBundle().put(recordIdGen, idFromResponseContent);
 }
    
    public Object concatenateBundleValueInOFS(String recordIdGen , String ofsString1, String bundleValueInOFS1 ,String ofsString2, String bundleValueInOFS2, String ofsString3 , String bundleValueInOFS3, String ofsString4) {
        
        //To concatenate 3 bundle value with the ofs string
     
        String ofsString = ofsString1+cucumberInteractionSession.scenarioBundle().getString(bundleValueInOFS1)+ofsString2 + cucumberInteractionSession.scenarioBundle().getString(bundleValueInOFS2)+ofsString3+cucumberInteractionSession.scenarioBundle().getString(bundleValueInOFS3)+ofsString4;
        System.out.println("OFS String to be executed: "+ofsString);
        
        String responseContents= JsonUtil.ExecuteOfsMessage(ofsString);
        
        System.out.println("OFS response: "+responseContents);
        
        if (responseContents.startsWith("<requests><req"))
        {
            idFromResponseContent = responseContents.split(">")[2].split("/")[0];
        }
        else
        {
            idFromResponseContent = responseContents.split("/")[0];
        }
        //To get the record id from ofs response
        //String  idFromResponseContent = responseContents.split("/")[0];
     
     System.out.println("Record Id in OFS response is :" + idFromResponseContent);
     return cucumberInteractionSession.scenarioBundle().put(recordIdGen, idFromResponseContent);
 }
    
    
    public Object bundleRecordIdAndOtherFieldValue(String recordIdKey, String fieldName , String bundleName, String ofsString) {
        
        String fieldValue = null;
        System.out.println("OFS String to be executed: "+ofsString);
        
        String responseContents= JsonUtil.ExecuteOfsMessage(ofsString);
        
        System.out.println("OFS response: "+responseContents);
        
        if (responseContents.startsWith("<requests><req"))
        {
            idFromResponseContent = responseContents.split(">")[2].split("/")[0];
        }
        else
        {
            idFromResponseContent = responseContents.split("/")[0];
        }
      
      //Field name ex: ACCOUNT.REFERENCE:1:1
      if(responseContents.contains(fieldName)) {
          
      int beginingIndex = responseContents.indexOf(fieldName);
      int commaIndex = responseContents.substring(beginingIndex).indexOf(",");
      
      fieldValue = responseContents.substring(beginingIndex+fieldName.length()+1,beginingIndex+commaIndex);
      System.out.println("Value of "+fieldName+" in OFS response is" + fieldValue);
      }
      else{
          
          System.out.println("Invalid field name "+fieldName+" or field name not present in response");
      }
     
     
      
     System.out.println("Record Id from OFS response is : "+idFromResponseContent); 
     cucumberInteractionSession.scenarioBundle().put(bundleName, fieldValue);
     cucumberInteractionSession.scenarioBundle().put(recordIdKey, idFromResponseContent);
     
     return cucumberInteractionSession;
 }
    
    public Object bundleOtherFieldValue(String fieldName , String bundleName, String ofsString) {
        
        
        String fieldValue = null;
        System.out.println("OFS String to be executed: "+ofsString);
        
        String responseContents= JsonUtil.ExecuteOfsMessage(ofsString);
        
        System.out.println("OFS response: "+responseContents);
        

      
      //Field name ex: ACCOUNT.REFERENCE:1:1
      if(responseContents.contains(fieldName)) {
          
      int beginingIndex = responseContents.indexOf(fieldName);
      int commaIndex = responseContents.substring(beginingIndex).indexOf(",");
      
      fieldValue = responseContents.substring(beginingIndex+fieldName.length()+1,beginingIndex+commaIndex);
      System.out.println("Value of "+fieldName+" in OFS response is" + fieldValue);
      }
      else{
          
          System.out.println("Invalid field name "+fieldName+" or field name not present in response");
      }
     
    
     return cucumberInteractionSession.scenarioBundle().put(bundleName, fieldValue);
     
 }
    
    public Object bundleOtherFieldValue(String fieldName1 , String bundleName1, String fieldName2, String bundleName2, String ofsString1, String bundleValueInOFS, String ofsString2 ) {
        
        
        String ofsString = ofsString1+cucumberInteractionSession.scenarioBundle().getString(bundleValueInOFS)+ofsString2;
        
        String fieldValue1 = null;
        String fieldValue2 = null;
        System.out.println("OFS String to be executed: "+ofsString);
        
        String responseContents= JsonUtil.ExecuteOfsMessage(ofsString);
        
        System.out.println("OFS response: "+responseContents);
        

      
      //Field name ex: ACCOUNT.REFERENCE:1:1
      if(responseContents.contains(fieldName1)) {
          
      int beginingIndex = responseContents.indexOf(fieldName1);
      int commaIndex = responseContents.substring(beginingIndex).indexOf(",");
      
      fieldValue1 = responseContents.substring(beginingIndex+fieldName1.length()+1,beginingIndex+commaIndex);
      System.out.println("Value of "+fieldName1+" in OFS response is" + fieldValue1);
      }
      else{
          
          System.out.println("Invalid field name "+fieldName1+" or field name not present in response");
      }
      
      //Field name ex: ACCOUNT.REFERENCE:1:1
      if(responseContents.contains(fieldName2)) {
          
      int beginingIndex = responseContents.indexOf(fieldName2);
      int commaIndex = responseContents.substring(beginingIndex).indexOf(",");
      
      fieldValue2 = responseContents.substring(beginingIndex+fieldName2.length()+1,beginingIndex+commaIndex);
      System.out.println("Value of "+fieldName2+" in OFS response is" + fieldValue2);
      }
      else{
          
          System.out.println("Invalid field name "+fieldName2+" or field name not present in response");
      }
     
    
     cucumberInteractionSession.scenarioBundle().put(bundleName1, fieldValue1);
     cucumberInteractionSession.scenarioBundle().put(bundleName2, fieldValue2);
     
     return cucumberInteractionSession;
     
 }
    
    public Object concatenateBundleValueInOFSWithRecIdAndFieldValue(String recordIdGen ,String fieldName, String fieldValueBundle , String ofsString1, String bundleValueInOFS,String ofsString2) {
        
        //To concatenate 1 bundle value with the ofs string
        
        String fieldValue = null;
        String ofsString = ofsString1+cucumberInteractionSession.scenarioBundle().getString(bundleValueInOFS)+ofsString2;
        
        System.out.println("OFS String to be executed: "+ofsString);
        
        String responseContents= JsonUtil.ExecuteOfsMessage(ofsString);
        
        System.out.println("OFS response: "+responseContents);
        
        if (responseContents.startsWith("<requests><req"))
        {
            idFromResponseContent = responseContents.split(">")[2].split("/")[0];
        }
        else
        {
            idFromResponseContent = responseContents.split("/")[0];
        }
        
      //Field name ex: ACCOUNT.REFERENCE:1:1
        if(responseContents.contains(fieldName)) {
            
        int beginingIndex = responseContents.indexOf(fieldName);
        int commaIndex = responseContents.substring(beginingIndex).indexOf(",");
        
        fieldValue = responseContents.substring(beginingIndex+fieldName.length()+1,beginingIndex+commaIndex);
        System.out.println("Value of "+fieldName+" in OFS response is" + fieldValue);
        }
        else{
            
            System.out.println("Invalid field name "+fieldName+" or field name not present in response");
        }    
       
      //To get the record id from ofs response
      //String  idFromResponseContent = responseContents.split("/")[0];     
     System.out.println("Record Id in OFS response is :" + idFromResponseContent);
     cucumberInteractionSession.scenarioBundle().put(recordIdGen, idFromResponseContent);
     cucumberInteractionSession.scenarioBundle().put(fieldValueBundle, fieldValue);
     return cucumberInteractionSession;
 }
    
    }
    
