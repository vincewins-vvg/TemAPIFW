package com.temenos.microservice.payments.ingester;

import org.json.JSONObject;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DatabaseOperationException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.IngestionFailedException;
import com.temenos.microservice.framework.core.function.InvalidEventException;
import com.temenos.microservice.framework.core.ingester.GenericIngestionFunction;
import com.temenos.microservice.framework.core.ingester.IngesterEvent;

/**
 * PaymentOrderIngester.
 * 
 * @author kdhanraj
 *
 */
public class PaymentOrderIngester extends GenericIngestionFunction {

	@Override
	public IngesterEvent<JSONObject> invoke(Context ctx, IngesterEvent<JSONObject> input) throws FunctionException {

		for (String schemaName : input.getSchemaNames()) {
			for (JSONObject record : input.getRecords(schemaName)) {
				try {
					new PaymentorderIngesterUpdater().update();
				} catch (FunctionException e) {
					if (e instanceof DatabaseOperationException) {
						throw new InvalidEventException(
								"Received event containes invalid data for holdings, please correct and redeliver", e);
					}
					throw new IngestionFailedException("Failed to ingest", e);
				}
			}
		}
		return null;
	}

}
