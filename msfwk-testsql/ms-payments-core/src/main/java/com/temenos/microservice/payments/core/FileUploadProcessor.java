package com.temenos.microservice.payments.core;

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
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.payments.dao.FileUploadDao;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.entity.FileUpload;
import com.temenos.microservice.payments.function.FileUploadInput;
import com.temenos.microservice.payments.view.ApiResponse;
import com.temenos.microservice.payments.view.DocumentDetails;
import com.temenos.microservice.payments.view.FileUploadRequest;

@Component
public class FileUploadProcessor {
	public static final Diagnostic apiDiagnostic = Logger.forDiagnostic().forComp("API");

	public ApiResponse invoke(Context ctx, FileUploadInput input) throws FunctionException {
		List<String> invalidFileNames = new ArrayList<>();
		apiDiagnostic.prepareInfo("Invoke Method Called").log();
		Optional<FileUploadRequest> fileUploadRequestOpt = input.getBody();
		FileUploadRequest fileUploadRequest = fileUploadRequestOpt.get();
		DocumentDetails documentDetails = fileUploadRequest.getDocumentDetails();
		ApiResponse apiResponse = new ApiResponse();
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
		for (com.temenos.microservice.framework.core.function.BinaryData binaryData : fileUploadRequest
				.getAttachments()) {
			apiDiagnostic.prepareInfo("Binary Data Name:: " + binaryData.getFilename()).log();
			apiDiagnostic.prepareInfo("Binary Data Mime:: " + binaryData.getMimetype()).log();
			apiDiagnostic.prepareInfo("Binary Data Data:: " + binaryData.getData()).log();
			FileUpload fileUpload = new FileUpload();
			fileUpload.setName(binaryData.getFilename());
			fileUpload.setMimeType(binaryData.getMimetype());
			if (documentDetails != null) {
				com.temenos.microservice.payments.entity.DocumentDetails docDetailsEntity = new com.temenos.microservice.payments.entity.DocumentDetails();
				docDetailsEntity.setId(documentDetails.getDocumentId());
				docDetailsEntity.setDocumentId(documentDetails.getDocumentId());
				docDetailsEntity.setDocumentName(documentDetails.getDocumentName());
				fileUpload.setDocumentDetails(docDetailsEntity);
			} else {
				throw new InvalidInputException(new FailureMessage("Input body null or empty","PAYM-PORD-A-2007"));
			}
			try {
				fileUpload.setData(new SerialBlob(binaryData.getData()));
				FileUploadDao.getInstance(FileUpload.class).getSqlDao().saveEntity(fileUpload);
			} catch (SerialException e) {
				throw new InvalidInputException(new FailureMessage(e.getMessage(),"PAYM-PORD-A-2005"));
			} catch (SQLException e) {
				throw new InvalidInputException(new FailureMessage(e.getMessage(),"PAYM-PORD-A-2006"));
			}
		}
		apiResponse.setMessage("File Uploaded SuccessFully");
		return apiResponse;
	}
	
	private List<String> getFileNameList() throws FunctionException{

		CriteriaBuilder criteriaBuilder = FileUploadDao.getInstance(FileUpload.class).getSqlDao().getEntityManager()
				.getCriteriaBuilder();
		CriteriaQuery<FileUpload> criteriaQuery = criteriaBuilder.createQuery(FileUpload.class);
		Root<FileUpload> root = criteriaQuery.from(FileUpload.class);
		criteriaQuery.select(root);
		List<FileUpload> fileUploadList = FileUploadDao.getInstance(FileUpload.class).getSqlDao()
				.executeCriteriaQuery(criteriaBuilder, criteriaQuery, root, null, FileUpload.class);
		List<String> fileNameList = new ArrayList<>();
		for (FileUpload fileupload : fileUploadList) {
			fileNameList.add(fileupload.getName());
		}
		return fileNameList;
	}
}
