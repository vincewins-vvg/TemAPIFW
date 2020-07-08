package com.temenos.microservice.payments.core;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.sql.Blob;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Component;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.camel.BinaryData;
import com.temenos.microservice.payments.dao.FileUploadDao;
import com.temenos.microservice.payments.dao.PaymentOrderDao;
import com.temenos.microservice.payments.entity.FileUpload;
import com.temenos.microservice.payments.function.FileDownloadInput;
import com.temenos.microservice.payments.view.UploadApiResponse;
@Component
public class FileDownloadProcessor {
	public UploadApiResponse invoke(Context ctx, FileDownloadInput input) throws FunctionException {
		UploadApiResponse apiResponse = new UploadApiResponse();
		BinaryData binarydata = new BinaryData();
		String fileName = input.getParams().get().getFileName().get(0);
		try {
			List<com.temenos.microservice.payments.entity.FileUpload> entities = null;
			CriteriaBuilder criteriaBuilder = FileUploadDao
					.getInstance(com.temenos.microservice.payments.entity.FileUpload.class).getSqlDao().getEntityManager()
					.getCriteriaBuilder();
			CriteriaQuery<com.temenos.microservice.payments.entity.FileUpload> criteriaQuery = criteriaBuilder
					.createQuery(com.temenos.microservice.payments.entity.FileUpload.class);
			Root<com.temenos.microservice.payments.entity.FileUpload> root = criteriaQuery
					.from(com.temenos.microservice.payments.entity.FileUpload.class);
			criteriaQuery.select(root);
			if (fileName != null) {
				List<Predicate> predicates = new ArrayList<Predicate>();
				predicates.add(criteriaBuilder
						.and(criteriaBuilder.equal(root.get("name"), fileName)));
				entities = FileUploadDao.getInstance(com.temenos.microservice.payments.entity.FileUpload.class)
						.getSqlDao().executeCriteriaQuery(criteriaBuilder, criteriaQuery, root, predicates,
								com.temenos.microservice.payments.entity.FileUpload.class);
			}
			
			
			FileUpload fileUpload = entities.get(0);
			binarydata.setFilename(fileUpload.getName());
			binarydata.setMimetype(fileUpload.getMimeType());
			Blob blob =fileUpload.getData();
	        byte [] bytes = blob.getBytes(1l, (int)blob.length());
			binarydata.setData(bytes);
			List<BinaryData> binaryDataList = new ArrayList<>();
			binaryDataList.add(binarydata);
			apiResponse.setAttachments(binaryDataList);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return apiResponse;
	}
}
