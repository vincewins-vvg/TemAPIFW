/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.function;


import com.temenos.logger.diagnostics.Diagnostic;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.log.Logger;
import com.temenos.microservice.payments.core.FileDeleteProcessor;
import com.temenos.microservice.payments.view.ApiResponse;

public class FileDeleteImpl implements FileDelete{
	
	public static final Diagnostic apiDiagnostic = Logger.forDiagnostic().forComp("API");

	@Override
	public ApiResponse invoke(Context ctx, FileDeleteInput input) throws FunctionException {
		apiDiagnostic.prepareInfo("Impl called").log();
		FileDeleteProcessor doDeleteUsingBeanProcessor 
		= (FileDeleteProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
				.instance().getBean(FileDeleteProcessor.class);
		return doDeleteUsingBeanProcessor.invoke(ctx, input);
	}

}
