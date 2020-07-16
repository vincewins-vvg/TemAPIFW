package com.temenos.microservice.paymentorder.function;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Optional;

import org.apache.commons.io.IOUtils;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.file.reader.FileReaderConstants;
import com.temenos.microservice.framework.core.file.reader.MSStorageReadAdapter;
import com.temenos.microservice.framework.core.file.reader.MSStorageReadAdapterFactory;
import com.temenos.microservice.framework.core.file.reader.StorageReadException;
import com.temenos.microservice.framework.core.function.BinaryData;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.FunctionInvocationException;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.util.MSFrameworkErrorConstant;
import com.temenos.microservice.paymentorder.view.FileDownloadParams;
import com.temenos.microservice.paymentorder.exception.NoDataFoundException;
import com.temenos.microservice.paymentorder.view.DownloadApiResponse;
import com.temenos.microservice.framework.core.conf.Environment;

public class FileDownloadImpl implements FileDownload {

	@Override
	public DownloadApiResponse invoke(Context ctx, FileDownloadInput input) throws FunctionException {
		BinaryData binarydata = new BinaryData();
		DownloadApiResponse apiResponse = new DownloadApiResponse();
		
		validate(input);
		
		Optional<com.temenos.microservice.paymentorder.entity.FileDetails> fileContent = getFileContent(
				input.getParams().get().getFileName().get(0));
		
		if (fileContent.isPresent()) {
			com.temenos.microservice.paymentorder.entity.FileDetails fileDetails = fileContent.get();
			binarydata.setFilename(fileDetails.getName());
			binarydata.setMimetype(fileDetails.getMimetype());
			
			binarydata.setData(readFileContent(fileDetails));
			
			apiResponse.setAttachment(binarydata);
		} else {
			FailureMessage failureMessage = new FailureMessage("No Data Found", "PAYM-PORD-A-2005");
			throw new NoDataFoundException(failureMessage);
		}
		return apiResponse;
	}

	/*
	 * Validate input data
	 * @return void
	 */
	private void validate(FileDownloadInput input) throws InvalidInputException {
		FileDownloadParams params = input.getParams().get();
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
	 * Read the file from storage
	 * @return byte[]
	 */
	private byte[] readFileContent(com.temenos.microservice.paymentorder.entity.FileDetails fileDetails) throws FunctionException{
		try {
			String StorageUrl = File.separator+ fileDetails.getName();
			MSStorageReadAdapter fileWriter = MSStorageReadAdapterFactory.getStorageReadAdapterInstance();
			InputStream inputStream = fileWriter.getFileAsInputStream(StorageUrl);
			byte[] bytes = IOUtils.toByteArray(inputStream);
			return bytes;
		} catch (StorageReadException e) {
			throw new InvalidInputException(e.getFailureMessages());
		} catch (IOException e) {
			throw new InvalidInputException(e.getMessage());
		}
	}
	
	/*
	 * Get the filecontent from the database.
	 * @return entity
	 */
	private Optional<com.temenos.microservice.paymentorder.entity.FileDetails> getFileContent(String fileName) throws FunctionException{
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.FileDetails> fileDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.FileDetails.class);
		Optional<com.temenos.microservice.paymentorder.entity.FileDetails> fileContent = fileDao
				.getByPartitionKey(fileName);
		return fileContent;
	}
	

}
