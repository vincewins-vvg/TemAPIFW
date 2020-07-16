package com.temenos.microservice.paymentorder.function;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import com.temenos.logger.Logger;
import com.temenos.logger.diagnostics.Diagnostic;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.file.writer.MSStorageWriteAdapter;
import com.temenos.microservice.framework.core.file.writer.MSStorageWriteAdapterFactory;
import com.temenos.microservice.framework.core.file.writer.StorageWriteException;
import com.temenos.microservice.framework.core.function.BinaryData;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.paymentorder.view.ApiResponse;
import com.temenos.microservice.paymentorder.view.DocumentDetails;
import com.temenos.microservice.paymentorder.view.FileUploadRequest;

public class FileUploadImpl implements FileUpload{


	@Override
	public ApiResponse invoke(Context ctx, FileUploadInput input) throws FunctionException {
		Optional<FileUploadRequest> fileUploadRequestOpt = input.getBody();
		FileUploadRequest fileUploadRequest = fileUploadRequestOpt.get();
		DocumentDetails documentDetails = fileUploadRequest.getDocumentDetails();
		ApiResponse apiResponse = new ApiResponse();
		validate(fileUploadRequest);
		for (BinaryData binaryData : fileUploadRequest.getAttachments()) {
			writeFileContent(binaryData);
			saveData(binaryData, documentDetails);
		}
		apiResponse.setMessage("File Uploaded Successfully");
		return apiResponse;
	}
	
	private List<String> getFileNameList() throws FunctionException {
		List<String> fileNameList = new ArrayList<>();
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.FileDetails> fileUploadDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.FileDetails.class);

		List<com.temenos.microservice.paymentorder.entity.FileDetails> entities = fileUploadDao.get();
		for (com.temenos.microservice.paymentorder.entity.FileDetails fileupload : entities) {
			fileNameList.add(fileupload.getName());
		}
		return fileNameList;
	}
	
	/*
	 * Store the file into specific folder
	 * @return void
	 */
	private void writeFileContent(BinaryData binaryData) throws FunctionException{
		try {
			if (!"".equalsIgnoreCase(binaryData.getFilename())) {
				String StorageUrl = File.separator + binaryData.getFilename();
				if (StorageUrl != null) {
					MSStorageWriteAdapter fileWriter = MSStorageWriteAdapterFactory.getStorageWriteAdapterInstance();
					InputStream myInputStream = new ByteArrayInputStream(binaryData.getData());
					fileWriter.uploadFileAsInputStream(StorageUrl, myInputStream, true);
				}
			} else {
				throw new InvalidInputException(new FailureMessage("No Attachment Found","PAYM-PORD-A-2005"));
			}
		} catch (StorageWriteException e) {
			throw new InvalidInputException(e.getMessage());
		}
	}
	
	/*
	 * validate input data
	 * @return void
	 */
	private void validate(FileUploadRequest fileUploadRequest) throws FunctionException{
		List<String> invalidFileNames = new ArrayList<>();
		if(fileUploadRequest.getAttachments().isEmpty()) {
			throw new InvalidInputException(new FailureMessage("No Attachment Found!!","PAYM-PORD-A-2005"));
		}
		for(com.temenos.microservice.framework.core.function.BinaryData binaryData : fileUploadRequest
				.getAttachments()) {
			List<String> fileNames = getFileNameList();
			if(fileNames.contains(binaryData.getFilename().trim())) {
				invalidFileNames.add(binaryData.getFilename());
			}
		}
		if(!invalidFileNames.isEmpty()) {
			throw new InvalidInputException(new FailureMessage("Files are already exist"+invalidFileNames,"PAYM-PORD-A-2006"));
		}
	}
	
	/*
	 * Save the file details into database
	 * @return void
	 */
	private void saveData(BinaryData binaryData, DocumentDetails documentDetails) throws FunctionException{
		com.temenos.microservice.paymentorder.entity.FileDetails fileDetails = new com.temenos.microservice.paymentorder.entity.FileDetails();
		fileDetails.setName(binaryData.getFilename());
		fileDetails.setMimetype(binaryData.getMimetype());
		if (documentDetails != null) {
			com.temenos.microservice.paymentorder.entity.DocumentDetails docDetailsEntity = new com.temenos.microservice.paymentorder.entity.DocumentDetails();
			docDetailsEntity.setId(documentDetails.getDocumentId());
			docDetailsEntity.setDocumentId(documentDetails.getDocumentId());
			docDetailsEntity.setDocumentName(documentDetails.getDocumentName());
			fileDetails.setDocumentdetails(docDetailsEntity);
		} else {
			throw new InvalidInputException(new FailureMessage("Input body null or empty","PAYM-PORD-A-2007"));
		}
		NoSqlDbDao<com.temenos.microservice.paymentorder.entity.FileDetails> FileDao = DaoFactory
				.getNoSQLDao(com.temenos.microservice.paymentorder.entity.FileDetails.class);
		FileDao.saveEntity(fileDetails);
	}
	

}
