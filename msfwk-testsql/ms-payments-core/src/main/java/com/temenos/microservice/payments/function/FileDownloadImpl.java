package com.temenos.microservice.payments.function;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.camel.BinaryData;
import com.temenos.microservice.payments.core.FileUploadProcessor;
import com.temenos.microservice.payments.core.FileDownloadProcessor;
import com.temenos.microservice.payments.view.UploadApiResponse;

public class FileDownloadImpl implements FileDownload{

	@Override
	public UploadApiResponse invoke(Context ctx, FileDownloadInput input) throws FunctionException {
		// TODO Auto-generated method stub
		FileDownloadProcessor fileDownloadProcessor 
		= (FileDownloadProcessor) com.temenos.microservice.framework.core.SpringContextInitializer
				.instance().getBean(FileDownloadProcessor.class);
		return fileDownloadProcessor.invoke(ctx, input);
	}

}
