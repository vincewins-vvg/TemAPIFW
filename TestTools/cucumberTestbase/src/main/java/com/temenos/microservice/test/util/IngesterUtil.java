package com.temenos.microservice.test.util;

import java.net.URI;
import java.util.UUID;

import com.temenos.microservice.framework.core.conf.Environment;

import io.cloudevents.json.Json;
import io.cloudevents.v1.CloudEventBuilder;
import io.cloudevents.v1.CloudEventImpl;

public class IngesterUtil {

	public static final String IS_CLOUD_EVENT = "temn.msf.ingest.is.cloud.event";

	public static String packageCloudEvent(byte[] avroEvent) {
		String eventId = UUID.randomUUID().toString();
		URI eventSource = URI.create("com.temenos.event.ms");
		String eventType = "com.temenos.event.ms.EVENT_DELIVERY";
		CloudEventImpl<String> cloudEvent = CloudEventBuilder.<String>builder().withType(eventType).withId(eventId)
				.withSource(eventSource).withDataBase64(avroEvent).build();
		return Json.encode(cloudEvent);
	}

	public static Boolean isCloudEvent() {
		return Boolean.parseBoolean(Environment.getEnvironmentVariable(IS_CLOUD_EVENT, "false"));
	}
}
