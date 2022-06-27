/**
 * *******************************************************************************
 * * Copyright © Temenos Headquarters SA 2021. All rights reserved.
 * *******************************************************************************
 */
package com.temenos.microservice.payments.funciton.test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Properties;

import org.apache.kafka.clients.CommonClientConfigs;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.config.SaslConfigs;
import org.apache.kafka.common.serialization.ByteArraySerializer;
import org.apache.kafka.common.serialization.StringSerializer;

import com.temenos.des.streamprocessor.exception.StreamProducerException;
import com.temenos.des.streamvendorio.core.stream.produce.StreamProducer;
import com.temenos.des.streamvendorio.kafka.producer.KafkaStreamProducer;
import com.temenos.des.streamvendorio.kinesis.producer.KinesisStreamProducer;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.ingester.IngesterConfigProperty;

public class PaymentOrderTester {

	private static final String DEFAULT_STREAM_KAFKA_BOOTSTRAP_SERVERS = "kafka:29092";

	public static void main(String[] args) throws IOException {
		StreamProducer producer = createStreamProducer("itest", "kafka");
		String content = new String(Files.readAllBytes(Paths.get("src/test/resources/SequenceCompleted.json")));
		System.out.println("content:" + content);
		producer.batch().add("paymentorder-event-topic", "key", new String(content).getBytes());
		try {
			producer.batch().send();
		} catch (StreamProducerException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Initialises producer as per the vendor passed in
	 * 
	 * @param producerName
	 * @param streamVendor
	 * @return
	 */
	private static StreamProducer createStreamProducer(String producerName, String streamVendor) {
		if ("kinesis".equals(streamVendor)) {
			return new KinesisStreamProducer.Builder().setAggregationEnabled(true).setKinesisPort(443)
					.setRegionName(Environment.getAwsRegion().getName()).producer();
		} else {
			String producerClientId = producerName != null && !producerName.isEmpty() ? producerName : "test-producer";
			Properties props = new Properties();
			props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG,
					Environment.getEnvironmentVariable(IngesterConfigProperty.STREAM_KAFKA_BOOTSTRAP_SERVERS.getName(),
							DEFAULT_STREAM_KAFKA_BOOTSTRAP_SERVERS));
			if ("true".equals(Environment
					.getEnvironmentVariable(IngesterConfigProperty.STREAM_KAFKA_SASL_ENABLED.getName(), "false"))) {
				props.put(CommonClientConfigs.SECURITY_PROTOCOL_CONFIG, Environment.getEnvironmentVariable(
						IngesterConfigProperty.STREAM_KAFKA_SECURITY_PROTOCOL.getName(), "SASL_SSL"));
				props.put(SaslConfigs.SASL_MECHANISM, Environment
						.getEnvironmentVariable(IngesterConfigProperty.STREAM_KAFKA_SASL_MECHANISM.getName(), "PLAIN"));
				props.put(SaslConfigs.SASL_JAAS_CONFIG, Environment.getEnvironmentVariable(
						IngesterConfigProperty.STREAM_KAFKA_SASL_JAAS_CONFIG.getName(),
						"org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"Endpoint=sb://des-topics.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=dUu03/v8U/mTWOu9LxhqYC4wzX+sb3G6/R/nwMnQmi0=\";"));
			}
			props.put(ProducerConfig.ACKS_CONFIG, "all");
			props.put(ProducerConfig.ENABLE_IDEMPOTENCE_CONFIG, true);
			props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
			props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, ByteArraySerializer.class);
			props.put(ProducerConfig.BATCH_SIZE_CONFIG, 16384);
			props.put(ProducerConfig.LINGER_MS_CONFIG, 1);
			props.put(ProducerConfig.BUFFER_MEMORY_CONFIG, 33554432);
			return new KafkaStreamProducer.Builder().setProperties(props).setClientId(producerClientId)
					.setTransactional(false).producer();
		}
	}

}
