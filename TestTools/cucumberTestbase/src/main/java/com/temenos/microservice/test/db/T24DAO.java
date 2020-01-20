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
        long timeoutMillis = 60 * 1000;
        while(System.currentTimeMillis() - start < timeoutMillis) {
            try {
                String cusRec = "select COUNT(*) as resultCount from " + tableName + " where XMLRECORD LIKE '%" + CusId + "%' AND PROCESSEDTIME IS NOT NULL";
                System.out.println(cusRec);
                ResultSet rs = stmt.executeQuery(cusRec);
                if (rs.next()){
                    if(rs.getInt("resultCount") == 1);
                    return;
                }
                else {
                    log.info("Waiting to fetch record from FBNK_DATA_EVENTS for CusID: {}", CusId );
                }
            } catch (Exception e) {
                fail("Error in executing select statement on t24 db: " + e);
            }
        }
        fail("Timed out Waiting to fetch record from FBNK_DATA_EVENTS for CusID: " + CusId);
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
