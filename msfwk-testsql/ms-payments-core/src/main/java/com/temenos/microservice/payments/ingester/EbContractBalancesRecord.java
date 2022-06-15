/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.ingester;

import org.json.JSONArray;
import org.json.JSONObject;

public class EbContractBalancesRecord {

    private JSONObject sourceRecord;

    private String coCode;
    private String recId;
    private String stmtProcDate;
    private String onlineClearedBal;
    private String workingBalance;
    private String onlineActualBal;
    private String currency;
    private String customer;
    private String product;
    private String processingTime;

    public EbContractBalancesRecord(JSONObject sourceRecord) {
        this.sourceRecord = sourceRecord;
        transform();
    }

    public String coCode() {
        return coCode;
    }

    public String recId() {
        return recId;
    }

    public String stmtProcDate() {
        return stmtProcDate;
    }

    public String onlineClearedBal() {
        return onlineClearedBal;
    }

    public String workingBalance() {
        return workingBalance;
    }

    public String onlineActualBal() {
        return onlineActualBal;
    }

    public String currency() {
        return currency;
    }

    public String customer() {
        return customer;
    }

    public String product() {
        return product;
    }

    private void transform() {
        JSONObject payload = sourceRecord.getJSONObject("payload");

        recId = payload.optString("recId");
        currency = payload.optString("Currency");					// 1
        coCode = payload.optString("CoCode");						// 16
        product = payload.optString("Product");						// 20
        customer = payload.optString("Customer");					// 22
        processingTime = sourceRecord.optString("processingTime");
        JSONArray arrStmtProcDate = payload.optJSONArray("ARRAY_StmtProcDate");
        JSONObject recStmtProcDate = arrStmtProcDate.optJSONObject(0);
        if (recStmtProcDate != null) {
            stmtProcDate = recStmtProcDate.optJSONObject("RECORD_StmtProcDate").optString("StmtProcDate"); //59
        }
        
        onlineActualBal = payload.optString("OnlineActualBal");		//70
        onlineClearedBal = payload.optString("OnlineClearedBal");	//71
        workingBalance = payload.optString("WorkingBalance"); 		//72
    }

	public String getProcessingTime() {
		return processingTime;
	}
}