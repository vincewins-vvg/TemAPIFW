/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.ingester;

import static com.temenos.microservice.framework.core.logger.constants.LoggerConstants.INGESTER_ALERT;
import static com.temenos.microservice.framework.core.logger.constants.LoggerConstants.INGESTER_DIAGNOSTIC;

import java.io.IOException;

import org.json.JSONObject;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.temenos.inboxoutbox.core.GenericCommand;
import com.temenos.inboxoutbox.core.GenericEvent;
import com.temenos.inboxoutbox.function.InboxOutboxException;
import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.conf.MSLogCode;
import com.temenos.microservice.framework.core.data.ConcurrentUpdateException;
import com.temenos.microservice.framework.core.data.IntegrityConstraintException;
import com.temenos.microservice.framework.core.function.BaseProcessor;
import com.temenos.microservice.framework.core.function.Context;
import com.temenos.microservice.framework.core.function.InvalidInputException;
import com.temenos.microservice.framework.core.function.PrintStackError;
import com.temenos.microservice.framework.core.ingester.BinaryIngesterUpdater;
import com.temenos.microservice.framework.core.ingester.CommandInputBuilder;
import com.temenos.microservice.framework.core.ingester.Transformation;
import com.temenos.microservice.framework.core.ingester.TransformationFactory;
import com.temenos.microservice.framework.core.outbox.EventManager;
import com.temenos.microservice.framework.core.util.CloudEventUtil;
import com.temenos.microservice.framework.core.util.FrameworkConstants;

public class POCommandIngester extends BinaryIngesterUpdater {

	GenericCommand command = null;
	BaseProcessor baseProcessor = null;
	private static final String JOLT_SPEC = "joltspec";
	@Override
	public void transform(byte[] binaryObject) throws FunctionException {
		INGESTER_DIAGNOSTIC.prepareDebug("Message received").tag("ClassName", this.getClass().getName()).log();
		try {
			if (CloudEventUtil.isCloudEvent(context)) {
				byte[] transformedBinary = applyJoltTransform(context, new String(binaryObject));
				command = CloudEventUtil.transformToCommand(transformedBinary);
			} else {
				
				ObjectMapper mapper = new ObjectMapper();
				mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
				command = mapper.readValue(binaryObject, GenericCommand.class);
			}
			INGESTER_DIAGNOSTIC.prepareDebug("Transformed incoming message").tag("eventId", command.getEventId()).log();
			String UUID = command.getEventId();
			INGESTER_DIAGNOSTIC.prepareDebug("Transformed incoming message").tag("ms.requestuuid", command.getEventId())
					.tag("ms.operationid", command.getEventType()).tag("ClassName", this.getClass().getName()).log();
		} catch (IOException | InboxOutboxException e) {
			INGESTER_ALERT.prepareError(MSLogCode.OBJECT_MAPPING_FAILED).tag("Transformation failed", e)
					.tag("ClassName", this.getClass().getName()).log();
			throw new InvalidInputException(e.getMessage(), e);
		}
		
	}
	
	
	@Override
	public void preProcess(Context context) throws FunctionException {
		String operationId = null;
		try {
			baseProcessor = new BaseProcessor();
			baseProcessor.setCommand(command);
			baseProcessor.storeUUIdInContext(context);
			operationId = baseProcessor.isBusinessEvent() ? command.getEventType()
					: command.getEventType().split("\\.")[1];
			CommandInputBuilder.buildRequest(context, operationId, command);
			if (!baseProcessor.isBusinessEvent())
				CommandInputBuilder.setBody(context, command);
			baseProcessor.setOperationId(operationId);
			baseProcessor.invokePreHook(context);
		} catch (IntegrityConstraintException | ConcurrentUpdateException e) {
			INGESTER_ALERT.prepareError(MSLogCode.CONCURRENT_UPDATION_FAILED)
					.tag("Concurrent Update/ Integrity Constraint Violation Occurred", e.getMessage())
					.tag("ClassName", this.getClass().getName()).log();
			throw e;
		} catch (Exception e) {
			PrintStackError.printStackLog(e, "");
			throw e;
		}
	}
	
	private byte[] applyJoltTransform(Context context, String incomingData) throws FunctionException {
		String transformedData = incomingData;
		String joltSpec = (String) CloudEventUtil.getCloudEventHeader(context, JOLT_SPEC);
		if (joltSpec != null && !joltSpec.isEmpty()) {
			JSONObject incomingObject = new JSONObject(incomingData);
			JSONObject transformedObject = new JSONObject();
			Transformation transformer = TransformationFactory.getTransformationInstance();
			transformedObject = (JSONObject) transformer.transformProductFields(joltSpec,
					FrameworkConstants.EMPTY_STRING, transformedObject, incomingObject);
			transformedData = transformedObject.toString();
			INGESTER_DIAGNOSTIC.debug("Transformed data: " + transformedData);
		}
		return transformedData.getBytes();
	}

	@Override
	public void process(Context context) throws FunctionException {
		EventManager.raiseBusinessEvent(context, new GenericEvent(command));
	}
	
	@Override
	public void postProcess(Context context) throws FunctionException {
		//baseProcessor.invokePostHook(context);
	}

}
