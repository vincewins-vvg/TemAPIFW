package com.temenos.microservice.paymentorder.ingester;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.ingester.BinaryIngesterUpdater;

public class PaymentOrderBusinessIngester extends BinaryIngesterUpdater {

	@Override
	public void transform(byte[] binaryObject) throws FunctionException {
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void process(Context context) throws FunctionException {
		// TODO Auto-generated method stub
		
	}

	

}
