package com.temenos.microservice.paymentorder.function;

import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Optional;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.data.DaoFactory;
import com.temenos.microservice.framework.core.data.NoSqlDbDao;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.function.camel.BinaryData;
import com.temenos.microservice.paymentorder.view.FileDownloadParams;
import com.temenos.microservice.paymentorder.view.UploadApiResponse;

public class FileDownloadImpl implements FileDownload{

	@Override
	public UploadApiResponse invoke(Context ctx, FileDownloadInput input) throws FunctionException {
		BinaryData binarydata = new BinaryData();
		UploadApiResponse apiResponse = new UploadApiResponse();
		if (input.getParams().get() != null) {
			FileDownloadParams params = input.getParams().get();
			validateParam(params);

			NoSqlDbDao<com.temenos.microservice.paymentorder.entity.FileUpload> fileDownloadDao = DaoFactory
					.getNoSQLDao(com.temenos.microservice.paymentorder.entity.FileUpload.class);
			Optional<com.temenos.microservice.paymentorder.entity.FileUpload> fileDownload = fileDownloadDao
					.getByPartitionKey(input.getParams().get().getFileName().get(0));
			if (fileDownload.isPresent()) {
				com.temenos.microservice.paymentorder.entity.FileUpload fileUpload = fileDownload.get();
				binarydata.setFilename(fileUpload.getName());
				binarydata.setMimetype(fileUpload.getMimetype());
				String encodedData = fileUpload.getData();
				byte[] bytes = Base64.getDecoder().decode(encodedData);
				binarydata.setData(bytes);
				List<BinaryData> binaryDataList = new ArrayList<>();
				binaryDataList.add(binarydata);
				apiResponse.setAttachments(binaryDataList);
			} else {
				throw new InvalidInputException(
						new FailureMessage("No Data Found", "PAYM-PORD-A-2002"));
			}
		} 
		return apiResponse;
	}
	
	private void validateParam(FileDownloadParams params) throws InvalidInputException {
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

}
