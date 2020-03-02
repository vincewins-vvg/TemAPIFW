package com.temenos.microservice.test.db;

import static junit.framework.TestCase.fail;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.temenos.microservice.framework.core.conf.Environment;

public class T24DAO {
    private static final Logger log = LoggerFactory.getLogger(T24DAO.class.getName());
   Statement stmt;
   Connection connection;
   private String T24_DB_USER;
   private String T24_DB_PWD;
   private String T24_DB_URL;
 
    public T24DAO()throws Exception{
        getDBConnection();
    }

    public void executeQuery(String CusId, String tableName){ 
        long start = System.currentTimeMillis();
        long timeoutMillis = 60 * 10000;
        String cusRec;
        String tafjVocCheck;
        log.info("Waiting to check for entry in " + tableName + " for the Record Id: {}", CusId );
        //System.out.println("select COUNT(*) as resultCount from " + tableName + " where RECID ='" +CusId+"'");
        //log.info("Querying --> select COUNT(*) as resultCount from " + tableName + " where RECID ='" +CusId+"'");
        
        while(System.currentTimeMillis() - start < timeoutMillis) {
            
            try {
                
                if (tableName.contains("DATA_EVENTS"))
                {
                cusRec = "select COUNT(*) as resultCount from " + tableName + " where XMLRECORD LIKE '%transactionRef=" + CusId + "%'";
//                tafjVocCheck = "SELECT COUNT(*) as isAttributePresent FROM " + tableName + " where RECID ='" +CusId+ "'" ;
//                
//                ResultSet rs1 = stmt.executeQuery(tafjVocCheck);
//                rs1.next();
//                short attribCount = rs1.getShort("tafjVocCheck");
//                if(attribCount==0){
//                    
//                    log.info("Allow attribute is not set to 'Y' in TAFJ_VOC table for the Record Id: {}", CusId );
//                    
//                }
                }
                else{
                    
                cusRec = "select COUNT(*) as resultCount from " + tableName + " where RECID ='" +CusId+"'";
                }
                ResultSet rs = stmt.executeQuery(cusRec);
                
                if (rs.next()){
                    short rowCount = rs.getShort("resultCount");
                    
                    if(rowCount == 1){
                    //System.out.print(rowCount);
                    //System.out.println(cusRec);
                    System.out.println("Entry for the created record " + CusId + " is present in " + tableName +  " table");
                    
                    return;
                }
//                    else {
//                        log.info("Waiting to check entry in " + tableName + " for the Record Id: {}", CusId );
//                    }
                }
                
            } catch (Exception e) {
                fail("Error in executing select statement on t24 db: " + e);
            }
        }
        fail("Timed out waiting to check if there is an entry for Record Id: " + CusId + "in table "+ tableName);
    }
    
    public void checkFDataEventsEntryStatus(String CusId, String tableName){
        long start = System.currentTimeMillis();
        long timeoutMillis = 60 * 10000;
   
        log.info("Waiting for the Record Id "+CusId+ " entry in " + tableName + " to be processed" );
        while(System.currentTimeMillis() - start < timeoutMillis) {
            try {
                String cusRec = "select COUNT(*) as resultCounts from " + tableName + " where XMLRECORD LIKE '%transactionRef=" + CusId + "%' AND PROCESSEDTIME IS NOT NULL";
                
                ResultSet rs = stmt.executeQuery(cusRec);
                
                if (rs.next()){
                    short rowcCount1 = rs.getShort("resultCounts");
                    if(rowcCount1 == 1){
                    
                    //System.out.print(rowcCount1);
                    System.out.println("Entry for the created record " + CusId + " has been processed in table " + tableName);
                    return;
                }
//                    else {
//                        log.info("Waiting for the entry in " + tableName + " to be processed for the Record Id: ", CusId );
//                    }
                }
                
                
            } catch (Exception e) {
                fail("Error in executing select statement on t24 db: " + e);
            }
        }
        fail("Timed out waiting to check if entry for Record Id: " + CusId + "in " + tableName + " table has been processed");
    }

    private void getDBConnection() throws Exception{
        this.T24_DB_URL = Environment.getEnvironmentVariable("T24_DB_URL", "");
        this.T24_DB_USER = Environment.getEnvironmentVariable("T24_DB_USER","");
        this.T24_DB_PWD = Environment.getEnvironmentVariable("T24_DB_PWD","");
        if(T24_DB_URL == null || T24_DB_USER == null || T24_DB_PWD == null){
            throw new RuntimeException("Mandatory system property 'T24_DB_URL' or 'T24_DB_USER' or 'T24_DB_PWD' is not set");
        }
        
        String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        Class.forName(driver).newInstance();
        connection = DriverManager.getConnection(T24_DB_URL, T24_DB_USER, T24_DB_PWD);
        stmt = connection.createStatement();

    } 
}
