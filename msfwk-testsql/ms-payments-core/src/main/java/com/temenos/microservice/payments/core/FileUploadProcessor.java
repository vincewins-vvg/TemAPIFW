package com.temenos.microservice.payments.core;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.Base64;
import java.util.List;
import java.util.Optional;
import java.util.ArrayList;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import javax.sql.rowset.serial.SerialBlob;
import javax.sql.rowset.serial.SerialException;

import org.springframework.stereotype.Component;

import com.temenos.logger.Logger;
import com.temenos.logger.diagnostics.Diagnostic;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.file.writer.MSStorageWriteAdapter;
import com.temenos.microservice.framework.core.file.writer.MSStorageWriteAdapterFactory;
import com.temenos.microservice.framework.core.file.writer.StorageWriteException;
import com.temenos.microservice.framework.core.function.BinaryData;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.payments.dao.FileUploadDao;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.entity.FileDetails;
import com.temenos.microservice.payments.function.FileUploadInput;
import com.temenos.microservice.payments.view.ApiResponse;
import com.temenos.microservice.payments.view.DocumentDetails;
import com.temenos.microservice.payments.view.FileUploadRequest;

@Component
public class FileUploadProcessor {
	public static final Diagnostic apiDiagnostic = Logger.forDiagnostic().forComp("API");

	public ApiResponse invoke(Context ctx, FileUploadInput input) throws FunctionException {
		apiDiagnostic.prepareInfo("Invoke Method Called").log();
		Optional<FileUploadRequest> fileUploadRequestOpt = input.getBody();
		FileUploadRequest fileUploadRequest = fileUploadRequestOpt.get();
		DocumentDetails documentDetails = fileUploadRequest.getDocumentDetails();
		ApiResponse apiResponse = new ApiResponse();
		validate(fileUploadRequest);
		for (com.temenos.microservice.framework.core.function.BinaryData binaryData : fileUploadRequest
				.getAttachments()) {
			writeFileContent(binaryData);
			saveData(binaryData, documentDetails);
		}
		apiResponse.setMessage("File Uploaded SuccessFully");
		return apiResponse;
	}

	private List<String> getFileNameList() throws FunctionException {

		CriteriaBuilder criteriaBuilder = FileUploadDao.getInstance(FileDetails.class).getSqlDao().getEntityManager()
				.getCriteriaBuilder();
		CriteriaQuery<FileDetails> criteriaQuery = criteriaBuilder.createQuery(FileDetails.class);
		Root<FileDetails> root = criteriaQuery.from(FileDetails.class);
		criteriaQuery.select(root);
		List<FileDetails> fileUploadList = FileUploadDao.getInstance(FileDetails.class).getSqlDao()
				.executeCriteriaQuery(criteriaBuilder, criteriaQuery, root, null, FileDetails.class);
		List<String> fileNameList = new ArrayList<>();
		for (FileDetails fileupload : fileUploadList) {
			fileNameList.add(fileupload.getName());
		}
		return fileNameList;
	}
	
	/*
	 * validate input data
	 * @return void
	 */
	private void validate(FileUploadRequest fileUploadRequest) throws FunctionException {
		List<String> invalidFileNames = new ArrayList<>();
		if (fileUploadRequest.getAttachments().isEmpty()) {
			throw new InvalidInputException(new FailureMessage("No Attachment Found!!", "PAYM-PORD-A-2005"));
		}
		for (com.temenos.microservice.framework.core.function.BinaryData binaryData : fileUploadRequest
				.getAttachments()) {
			List<String> fileNames = getFileNameList();
			if (fileNames.contains(binaryData.getFilename().trim())) {
				invalidFileNames.add(binaryData.getFilename());
			}
		}
		if (!invalidFileNames.isEmpty()) {
			throw new InvalidInputException(
					new FailureMessage("Files are already exist" + invalidFileNames, "PAYM-PORD-A-2006"));
		}
	}
	
	/*
	 * Store the file into specific folder
	 * @return void
	 */
	private void writeFileContent(BinaryData binaryData) throws FunctionException{
		try {
			String StorageUrl = File.separator+binaryData.getFilename();
			if (StorageUrl != null) {
				MSStorageWriteAdapter fileWriter = MSStorageWriteAdapterFactory.getStorageWriteAdapterInstance();
				InputStream myInputStream = new ByteArrayInputStream(binaryData.getData());
				fileWriter.uploadFileAsInputStream(StorageUrl, myInputStream, true);
			}
		} catch (StorageWriteException e) {
			throw new InvalidInputException(e.getMessage());
		}
	}
	
	/*
	 * Save the file details into database
	 * @return void
	 */
	private void saveData(BinaryData binaryData, DocumentDetails documentDetails) throws FunctionException{
		FileDetails fileUpload = new FileDetails();
		fileUpload.setName(binaryData.getFilename());
		fileUpload.setMimeType(binaryData.getMimetype());
		if (documentDetails != null) {
			com.temenos.microservice.payments.entity.DocumentDetails docDetailsEntity = new com.temenos.microservice.payments.entity.DocumentDetails();
			docDetailsEntity.setId(documentDetails.getDocumentId());
			docDetailsEntity.setDocumentId(documentDetails.getDocumentId());
			docDetailsEntity.setDocumentName(documentDetails.getDocumentName());
			fileUpload.setDocumentDetails(docDetailsEntity);
		} else {
			throw new InvalidInputException(new FailureMessage("Input body null or empty", "PAYM-PORD-A-2007"));
		}
		FileUploadDao.getInstance(FileDetails.class).getSqlDao().saveEntity(fileUpload);
	}

}
