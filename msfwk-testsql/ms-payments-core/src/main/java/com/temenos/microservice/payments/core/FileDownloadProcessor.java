package com.temenos.microservice.payments.core;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.apache.commons.io.IOUtils;
import org.springframework.stereotype.Component;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.file.reader.FileReaderConstants;
import com.temenos.microservice.framework.core.file.reader.MSStorageReadAdapter;
import com.temenos.microservice.framework.core.file.reader.MSStorageReadAdapterFactory;
import com.temenos.microservice.framework.core.file.reader.StorageReadException;
import com.temenos.microservice.framework.core.function.BinaryData;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.FailureMessage;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.payments.dao.FileUploadDao;
import com.temenos.microservice.payments.entity.FileDetails;
import com.temenos.microservice.payments.function.FileDownloadInput;
import com.temenos.microservice.payments.view.DownloadApiResponse;
import com.temenos.microservice.payments.view.FileDownloadParams;

@Component
public class FileDownloadProcessor {
	public DownloadApiResponse invoke(Context ctx, FileDownloadInput input) throws FunctionException {
		DownloadApiResponse apiResponse = new DownloadApiResponse();
		BinaryData binarydata = new BinaryData();
		List<BinaryData> binaryDataList = new ArrayList<>();
		String fileName = input.getParams().get().getFileName().get(0);
		validateParam(input.getParams().get());
		List<com.temenos.microservice.payments.entity.FileDetails> entities = getFileContent(fileName);
		if (entities == null || entities.isEmpty()) {
			throw new InvalidInputException(new FailureMessage("No Data Found", "PAYM-PORD-A-2005"));
		} else {
			FileDetails fileDetails = entities.get(0);
			binarydata.setFilename(fileDetails.getName());
			binarydata.setMimetype(fileDetails.getMimeType());
			byte[] fileContentBytes = readFileContent(fileDetails.getName());
			binarydata.setData(fileContentBytes);
			binaryDataList.add(binarydata);
			apiResponse.setAttachments(binaryDataList);
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

	/*
	 * Read the file from storage
	 * @return byte[]
	 */
	private byte[] readFileContent(String fileName) throws FunctionException{
		try {
			String StorageUrl = File.separator+ fileName;
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
	 * @return FileDetails
	 */
	private List<com.temenos.microservice.payments.entity.FileDetails> getFileContent(String fileName) throws FunctionException{
		List<com.temenos.microservice.payments.entity.FileDetails> entities = null;
		CriteriaBuilder criteriaBuilder = FileUploadDao
				.getInstance(com.temenos.microservice.payments.entity.FileDetails.class).getSqlDao().getEntityManager()
				.getCriteriaBuilder();
		CriteriaQuery<com.temenos.microservice.payments.entity.FileDetails> criteriaQuery = criteriaBuilder
				.createQuery(com.temenos.microservice.payments.entity.FileDetails.class);
		Root<com.temenos.microservice.payments.entity.FileDetails> root = criteriaQuery
				.from(com.temenos.microservice.payments.entity.FileDetails.class);
		criteriaQuery.select(root);
		if (fileName != null) {
			List<Predicate> predicates = new ArrayList<Predicate>();
			predicates.add(criteriaBuilder.and(criteriaBuilder.equal(root.get("name"), fileName)));
			entities = FileUploadDao.getInstance(com.temenos.microservice.payments.entity.FileDetails.class).getSqlDao()
					.executeCriteriaQuery(criteriaBuilder, criteriaQuery, root, predicates,
							com.temenos.microservice.payments.entity.FileDetails.class);
		}
		return entities;
	}
}
