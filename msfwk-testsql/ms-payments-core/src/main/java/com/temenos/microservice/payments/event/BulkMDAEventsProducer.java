package com.temenos.microservice.payments.event;

import static com.temenos.microservice.framework.core.logger.constants.LoggerConstants.SCHEDULER_DIAGNOSTIC;

import java.util.ArrayList;

import com.temenos.microservice.framework.core.FunctionException;
import com.temenos.microservice.framework.core.bulk.BulkEntities;
import com.temenos.microservice.framework.core.bulk.IBulkEventProducer;
import com.temenos.microservice.framework.core.data.Entity;
import com.temenos.microservice.framework.core.mdal.MdaEvent;
import com.temenos.microservice.framework.core.mdal.MdalKeys;
import com.temenos.microservice.framework.core.mdal.ParametersEvent;
import com.temenos.microservice.payments.entity.PaymentOrder;

/* 
 * BulkMDALEventsProducer prepares MDAL Events for all the entities provided. 
 * BulkMDALEventsProducer raised events are used to synchronize data in MDALCACHE
 * */
public class BulkMDAEventsProducer implements IBulkEventProducer {

	public MdaEvent constructEvents(BulkEntities bulkEntities) {

		if (bulkEntities == null) {

			return null;
		}
		ArrayList<MdalKeys> events = new ArrayList<MdalKeys>();

		SCHEDULER_DIAGNOSTIC.prepareInfo("BulkEntities  Size ::::  " + bulkEntities.getEntities().size())
				.tag("ClassName", "EntityExtractFunction ").log();

		// For each entity , prepare mdaleventpayload and add it to the MDAL Event
		bulkEntities.getEntities().forEach((entityObj) -> {
			// prepare MDAL event based on the entity type
			try {
				prepareMDALEvent(bulkEntities.getEntityName(), entityObj, events);
			} catch (FunctionException e) {
				SCHEDULER_DIAGNOSTIC.prepareInfo("Exception occurred!  " + e.getMessage())
						.tag("ClassName", "EntityExtractFunction ").log();
			}

		});

		MdaEvent mdalevent = new MdaEvent();
		mdalevent.setMdalevent(events);
		SCHEDULER_DIAGNOSTIC.prepareInfo("MdalEvent Event Size ::::  " + events.size())
				.tag("ClassName", "EntityExtractFunction ").log();

		// return mdal event // constant
		// processBulkMdalEvent
		return mdalevent;
	}

	private void prepareMDALEvent(String entityName, Entity entityObj, ArrayList<MdalKeys> events)
			throws FunctionException {
		switch (entityName) {
		case "paymentorder":
			prepareAndAddMDALEvent(entityObj, events);
			break;
		}
	}

	private void prepareAndAddMDALEvent(Entity entityObj, ArrayList<MdalKeys> events) throws FunctionException {
		PaymentOrder payment = (PaymentOrder) entityObj;
		MdalKeys event = new MdalKeys();
		event.setTarget("MDLPAT.Paymentorder");
		event.setScope("paymentorder");

		ArrayList<ParametersEvent> parametersList = new ArrayList<>();
		ParametersEvent parameters = new ParametersEvent();
		parameters.setKey("paymentId");
		parameters.setValue(payment.getPaymentOrderId());
		parametersList.add(parameters);
		event.setParameters(parametersList);
		events.add(event);
	}
}
