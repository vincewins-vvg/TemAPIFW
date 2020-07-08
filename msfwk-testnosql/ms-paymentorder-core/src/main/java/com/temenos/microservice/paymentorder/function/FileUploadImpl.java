package com.temenos.microservice.paymentorder.function;

import java.util.Base64;
import java.util.Optional;

import com.temenos.logger.Logger;
import com.temenos.logger.diagnostics.Diagnostic;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.paymentorder.view.ApiResponse;
import com.temenos.microservice.paymentorder.view.DocumentDetails;
import com.temenos.microservice.paymentorder.view.FileUploadRequest;

public class FileUploadImpl implements FileUpload{

	public static final Diagnostic apiDiagnostic = Logger.forDiagnostic().forComp("API");

	@Override
	public ApiResponse invoke(Context ctx, FileUploadInput input) throws FunctionException {
		apiDiagnostic.prepareInfo("Invoke Method Called").log();
		Optional<FileUploadRequest> fileUploadRequestOpt = input.getBody();
		FileUploadRequest fileUploadRequest = fileUploadRequestOpt.get();
		DocumentDetails documentDetails = fileUploadRequest.getDocumentDetails();
		ApiResponse apiResponse = new ApiResponse();
		for (com.temenos.microservice.framework.core.function.camel.BinaryData binaryData : fileUploadRequest
				.getAttachments()) {
			apiDiagnostic.prepareInfo("Binary Data Name:: " + binaryData.getFilename()).log();
			apiDiagnostic.prepareInfo("Binary Data Mime:: " + binaryData.getMimetype()).log();
			apiDiagnostic.prepareInfo("Binary Data Binary:: " + binaryData.getData()).log();

			com.temenos.microservice.paymentorder.entity.FileUpload fileUpload = new com.temenos.microservice.paymentorder.entity.FileUpload();
			fileUpload.setName(binaryData.getFilename());
			fileUpload.setMimetype(binaryData.getMimetype());
			if (documentDetails != null) {
				com.temenos.microservice.paymentorder.entity.DocumentDetails docDetailsEntity = new com.temenos.microservice.paymentorder.entity.DocumentDetails();
				docDetailsEntity.setId(documentDetails.getDocumentId());
				docDetailsEntity.setDocumentId(documentDetails.getDocumentId());
				docDetailsEntity.setDocumentName(documentDetails.getDocumentName());
				fileUpload.setDocumentdetails(docDetailsEntity);
			}
			fileUpload.setData(Base64.getEncoder().encodeToString(binaryData.getData()));
			NoSqlDbDao<com.temenos.microservice.paymentorder.entity.FileUpload> FileUploadDao = DaoFactory
					.getNoSQLDao(com.temenos.microservice.paymentorder.entity.FileUpload.class);
			FileUploadDao.saveEntity(fileUpload);
		}
		apiResponse.setMessage("File Uploaded Successfully");
		return apiResponse;
	}
	

}
