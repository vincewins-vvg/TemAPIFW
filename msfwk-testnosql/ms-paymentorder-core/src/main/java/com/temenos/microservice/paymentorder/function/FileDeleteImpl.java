package com.temenos.microservice.paymentorder.function;

import java.io.File;
import java.util.List;
import java.util.Optional;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.file.writer.MSStorageWriteAdapter;
import com.temenos.microservice.framework.core.file.writer.MSStorageWriteAdapterFactory;
import com.temenos.microservice.framework.core.file.writer.StorageWriteException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.paymentorder.exception.StorageException;
import com.temenos.microservice.paymentorder.view.ApiResponse;
import com.temenos.microservice.paymentorder.view.FileDeleteParams;

public class FileDeleteImpl implements FileDelete {

	@Override
	public ApiResponse invoke(Context ctx, FileDeleteInput input) throws FunctionException {
		ApiResponse apiResponse = new ApiResponse();		
		validate(input);
		if(input.getParams().get().getFileName() != null ) {
		deleteFileContent(input.getParams().get().getFileName().get(0));
		deleteFileContentFromDatabase(input.getParams().get().getFileName().get(0));
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
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.FileDetails> fileDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.FileDetails.class);
		Optional<com.temenos.microservice.paymentorder.entity.FileDetails> fileContent = fileDao
				.getByPartitionKey(fileName);
		com.temenos.microservice.paymentorder.entity.FileDetails fileDetailSample = fileContent.get();
		fileDao.deleteEntity(fileDetailSample);		
	}
}
