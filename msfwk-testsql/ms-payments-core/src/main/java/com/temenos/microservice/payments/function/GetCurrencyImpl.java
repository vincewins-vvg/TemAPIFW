package com.temenos.microservice.payments.function;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.payments.view.EnumCurrencies;
import com.temenos.microservice.payments.view.EnumCurrency;

public class GetCurrencyImpl implements GetCurrency {

	
	@Override
	public EnumCurrencies invoke(Context ctx, GetCurrencyInput input) throws FunctionException {
		EnumCurrencies currencyList = new EnumCurrencies();
		for (EnumCurrency currency : EnumCurrency.values()){
			currencyList.add(currency);
		}	  
		return currencyList;
	}
}
