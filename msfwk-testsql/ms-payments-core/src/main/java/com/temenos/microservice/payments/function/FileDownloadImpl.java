/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.function;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.payments.core.FileDownloadProcessor;
import com.temenos.microservice.payments.view.DownloadApiResponse;

public class FileDownloadImpl implements FileDownload{

	@Override
	public DownloadApiResponse invoke(Context ctx, FileDownloadInput input) throws FunctionException {
		// TODO Auto-generated method stub
		FileDownloadProcessor fileDownloadProcessor 
		= (FileDownloadProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
				.instance().getBean(FileDownloadProcessor.class);
		return fileDownloadProcessor.invoke(ctx, input);
	}

}
