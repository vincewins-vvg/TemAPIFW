package com.temenos.microservice.payments.core;

import java.io.File;
import java.util.List;

import org.springframework.stereotype.Component;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.file.writer.MSStorageWriteAdapter;
import com.temenos.microservice.framework.core.file.writer.MSStorageWriteAdapterFactory;
import com.temenos.microservice.framework.core.file.writer.StorageWriteException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.payments.dao.FileUploadDao;
import com.temenos.microservice.payments.entity.FileDetails;
import com.temenos.microservice.payments.exception.StorageException;
import com.temenos.microservice.payments.function.FileDeleteInput;
import com.temenos.microservice.payments.view.ApiResponse;
import com.temenos.microservice.payments.view.FileDeleteParams;

@Component
public class FileDeleteProcessor {

	public ApiResponse invoke(Context ctx, FileDeleteInput input) throws FunctionException {
		ApiResponse apiResponse = new ApiResponse();		
		validate(input);
		if(input.getParams().get().getFileName() != null ) {
		deleteFileContentFromDatabase(input.getParams().get().getFileName().get(0));
		deleteFileContent(input.getParams().get().getFileName().get(0));
		} else {
			throw new StorageException(
					new FailureMessage("Expecting proper request values", MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		}
		apiResponse.setMessage("File Deleted Successfully");
		return apiResponse;
	}
	
	/*
	 * Validate input data
	 * @return void
	 */
	private void validate(FileDeleteInput input) throws InvalidInputException {
		FileDeleteParams params = input.getParams().get();
		List<String> fileName = params.getFileName();
		if (fileName.size() != 1) {
			throw new InvalidInputException(
					new FailureMessage("Invalid  param. Only one FileName expected", "PAYM-PORD-A-2002"));
		}
		if (fileName.get(0).isEmpty()) {
			throw new InvalidInputException(
					new FailureMessage("Invalid  param. FileName is empty", "PAYM-PORD-A-2003"));
		}
	}
	
	
	/*
	 * delete the file from storage
	 * @return byte[]
	 */
	private void deleteFileContent(String fileName) throws FunctionException{
		try {
			String StorageUrl = File.separator+ fileName;
			MSStorageWriteAdapter fileWriter = MSStorageWriteAdapterFactory.getStorageWriteAdapterInstance();
			 fileWriter.deleteFile(StorageUrl);
		} catch (StorageWriteException e) {
			throw new StorageException(
					new FailureMessage(e.getMessage(), MSFrameworkErrorConstant.UNEXPECTED_ERROR_CODE));
		}
	}
	
	/*
	 * delete the filecontent from the database.
	 * @return void
	 */
	private void deleteFileContentFromDatabase(String fileName) throws FunctionException{
		FileDetails paymentDetailsOpt = (FileDetails) FileUploadDao.getInstance(com.temenos.microservice.payments.entity.FileDetails.class).getSqlDao().findById(fileName, com.temenos.microservice.payments.entity.FileDetails.class);
		FileUploadDao.getInstance(com.temenos.microservice.payments.entity.FileDetails.class).getSqlDao().deleteById(paymentDetailsOpt);
	}
}
