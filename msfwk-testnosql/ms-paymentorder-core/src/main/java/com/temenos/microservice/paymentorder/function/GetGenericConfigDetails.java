/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.paymentorder.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.Response;
import com.temenos.microservice.framework.core.util.GenericConfigUtil;
import com.temenos.microservice.paymentorder.view.Config;
import com.temenos.microservice.paymentorder.view.EnumCurrencies;
import com.temenos.microservice.paymentorder.view.GetConfigParams;

public class GetGenericConfigDetails implements GetConfig {

	@Override
	public Config invoke(Context ctx, GetConfigInput input) throws FunctionException {
		// TODO Auto-generated method stub
		GetConfigParams ConfigParams = input.getParams().get();
		String configGroup=ConfigParams.getConfigGroup().get(0);
		String configName=ConfigParams.getConfigName().get(0);
		Response<String> response = GenericConfigUtil.getGenericConfigData(configGroup, configName);
		String valueOfProperty =response.getBody();
		Config values= new Config();
		values.setConfigName(valueOfProperty);
		return values;
	}



}
