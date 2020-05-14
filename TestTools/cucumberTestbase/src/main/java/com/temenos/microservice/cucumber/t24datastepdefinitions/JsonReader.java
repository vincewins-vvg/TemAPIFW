package com.temenos.microservice.cucumber.t24datastepdefinitions;

import java.io.IOException;

import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONObject;

public class JsonReader {
    
    String update = "settlement(0)/payout(0)/property(0)/payoutAccount";

   public static void main(String[] args) {
       
  JsonReader r = new JsonReader();
  r.read();
           
   }
   
   public void read(){
       String payload = "";
       JSONObject jsonObjectBody = null;
       try {
           payload = IOUtils.toString(getClass().getClassLoader().getResourceAsStream("Partial_Deposit.json"));
       } catch (IOException e) {
           e.printStackTrace();
       }
       JSONObject jsonPayload = new JSONObject(payload);
       
       String last_field = "";
       
       String [] field = update.split("/");
       
       StringBuilder sb = new StringBuilder();
       JSONArray o = null;
       
       for(int i=0; i<field.length;i++){
           if(field[i].contains("(") && field[i].contains(")")){
               String key = field[i].substring(0,field[i].indexOf("("));
               String index = field[i].substring(field[i].indexOf("(")+1,field[i].indexOf(")"));
               if(key.equalsIgnoreCase("body")){
                jsonObjectBody = (JSONObject) jsonPayload.get("body");
               }
               
         //     o = jsonObjectBody.getJSONObject(key).getJSONArray(index).get(0);
                       
           //    sb.append(".getJSONObject(\"").append(key).append("\")");
           //    sb.append(".getJSONArray(").append(index).append(")");
           }
           if(i== field.length-1){
               last_field = field[i];
           }
         
           System.out.println(o);
           
      //     ((JSONObject) ((JSONObject) jsonObjectBody.getJSONObject("settlement").getJSONArray("payout").get(0))
        //           .getJSONArray("property").get(0)).put("payoutAccount", "12eee3");
           
          
       }
       System.out.println("Final :"+sb);
       
       System.out.println(jsonPayload);
       
   }
}
