package com.temenos.microservice.test.util;

import org.springframework.beans.factory.annotation.Autowired;

import com.temenos.microservice.cucumber.t24datastepdefinitions.JsonUtil;
import com.temenos.useragent.cucumber.steps.CucumberInteractionSession;

import cucumber.api.java8.En;

/**
 * Simulation services!
 *
 * @author mohamedasarudeen
 *
 */
public class ExecuteOFSString implements En {

    @Autowired
    private static CucumberInteractionSession cucumberInteractionSession;

    //public static String tafjBIN = System.getenv("TAFJ_HOME")+"/bin";
    //public static String tafjBIN = "C:/UTP/Temenos/TAFJ/bin";
    /**
     * @param args
     */
    public static void testOFSStringWithRecordIdGenerated(String RecId, String OfsMessageWithId) {
        // TODO Auto-generated method stub

        // exe specific service
        System.out.println("Id is " + RecId);
        String s = JsonUtil.ExecuteOfsMessageWithId(RecId,
                OfsMessageWithId); 
     
        
        System.out.println(s);

        
        

     //   String tafjBIN = "C:/DEVUTP/LatestDEV/UTP-DEV-2019.05.05-01-2344-saf-retailsuite-developer-s08/Temenos/TAFJ/bin";
        
//        try {
//           String op =  JsonUtil.execueCMD(100, "", tafjBIN);
//           
//           System.out.println(op);
//           
//           System.out.println("COMPLETED");
//        } catch (Exception e) {
//            e.printStackTrace();
//           
//            // TODO Auto-generated catch block
//            // Uncomment and replace with appropriate logger
//            // LOGGER.error(e, e);
//        }
//                
        // set start in TSM
//" "
        // RUN CMD tRUN START.TSM

    }
    
    
    public static void postOFSStringAndStoreId(String RecId, String customerOfsMessages) {
        // TODO Auto-generated method stub

       
        
        String s = JsonUtil.ExecuteOfsMessage(customerOfsMessages);
        
        
        System.out.println(s);
    }
        
    public static void testOFSString(String customerOfsMessage) {
        // TODO Auto-generated method stub

       
        
        String s = JsonUtil.ExecuteOfsMessage(customerOfsMessage);
        
        
        System.out.println(s);

        
        

     //   String tafjBIN = "C:/DEVUTP/LatestDEV/UTP-DEV-2019.05.05-01-2344-saf-retailsuite-developer-s08/Temenos/TAFJ/bin";
        
//        try {
//           String op =  JsonUtil.execueCMD(100, "", tafjBIN);
//           
//           System.out.println(op);
//           
//           System.out.println("COMPLETED");
//        } catch (Exception e) {
//            e.printStackTrace();
//           
//            // TODO Auto-generated catch block
//            // Uncomment and replace with appropriate logger
//            // LOGGER.error(e, e);
//        }
                
        // set start in TSM
//" "
        // RUN CMD tRUN START.TSM

    }
    
  }
