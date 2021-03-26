package com.temenos.microservice.payments.function;


import com.temenos.logger.diagnostics.Diagnostic;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.log.Logger;
import com.temenos.microservice.payments.core.FileUploadProcessor;
import com.temenos.microservice.payments.view.ApiResponse;

public class FileUploadImpl implements FileUpload{
	
	public static final Diagnostic apiDiagnostic = Logger.forDiagnostic().forComp("API");

	@Override
	public ApiResponse invoke(Context ctx, FileUploadInput input) throws FunctionException {
		apiDiagnostic.prepareInfo("Impl called").log();
		FileUploadProcessor doUploadUsingBeanProcessor 
		= (FileUploadProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
				.instance().getBean(FileUploadProcessor.class);
		return doUploadUsingBeanProcessor.invoke(ctx, input);
	}

}
