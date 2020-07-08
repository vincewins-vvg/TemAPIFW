package com.temenos.microservice.payments.core;

import java.sql.SQLException;
import java.util.Base64;
import java.util.Optional;

import javax.sql.rowset.serial.SerialBlob;
import javax.sql.rowset.serial.SerialException;

import org.springframework.stereotype.Component;

import com.temenos.logger.Logger;
import com.temenos.logger.diagnostics.Diagnostic;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.payments.dao.FileUploadDao;
import com.temenos.microservice.payments.entity.FileUpload;
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
		for (com.temenos.microservice.framework.core.function.camel.BinaryData binaryData : fileUploadRequest
				.getAttachments()) {
			apiDiagnostic.prepareInfo("Binary Data Name:: " + binaryData.getFilename()).log();
			apiDiagnostic.prepareInfo("Binary Data Mime:: " + binaryData.getMimetype()).log();
			apiDiagnostic.prepareInfo("Binary Data Binary:: " + binaryData.getData()).log();

			FileUpload fileUpload = new FileUpload();
			fileUpload.setName(binaryData.getFilename());
			fileUpload.setMimeType(binaryData.getMimetype());
			if (documentDetails != null) {
				com.temenos.microservice.payments.entity.DocumentDetails docDetailsEntity = new com.temenos.microservice.payments.entity.DocumentDetails();
				docDetailsEntity.setId(documentDetails.getDocumentId());
				docDetailsEntity.setDocumentId(documentDetails.getDocumentId());
				docDetailsEntity.setDocumentName(documentDetails.getDocumentName());
				fileUpload.setDocumentDetails(docDetailsEntity);
			}
			try {
				fileUpload.setData(new SerialBlob(binaryData.getData()));
				FileUploadDao.getInstance(FileUpload.class).getSqlDao().saveEntity(fileUpload);
			} catch (SerialException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		apiResponse.setMessage("File Uploaded SuccessFully");
		return apiResponse;
	}
}
