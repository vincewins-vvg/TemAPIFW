package com.temenos.microservice.test.producer;

import java.util.Properties;

import org.apache.kafka.common.serialization.ByteArraySerializer;
import org.apache.kafka.common.serialization.StringSerializer;

import com.temenos.des.streamvendorio.core.stream.produce.StreamProducer;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.ingester.IngesterConfigProperty;

public class ProducerFactory {

	public static StreamProducer createStreamProducer(String producerName, String streamVendor) {
		if ("kinesis".equals(streamVendor)) {
			return (new com.temenos.des.streamvendorio.kinesis.producer.KinesisStreamProducer.Builder())
					.setAggregationEnabled(true).setKinesisPort(443L)
					.setRegionName(Environment.getAwsRegion().getName()).producer();
		} else {
			String producerClientId = producerName != null && !producerName.isEmpty() ? producerName : "test-producer";
			Properties props = new Properties();
			props.put("bootstrap.servers", Environment.getEnvironmentVariable(
					IngesterConfigProperty.STREAM_KAFKA_BOOTSTRAP_SERVERS.getName(), "kafka:29092"));
			if ("true".equals(Environment
					.getEnvironmentVariable(IngesterConfigProperty.STREAM_KAFKA_SASL_ENABLED.getName(), "false"))) {
				props.put("security.protocol", Environment.getEnvironmentVariable(
						IngesterConfigProperty.STREAM_KAFKA_SECURITY_PROTOCOL.getName(), "SASL_SSL"));
				props.put("sasl.mechanism", Environment
						.getEnvironmentVariable(IngesterConfigProperty.STREAM_KAFKA_SASL_MECHANISM.getName(), "PLAIN"));
				props.put("sasl.jaas.config", Environment.getEnvironmentVariable(
						IngesterConfigProperty.STREAM_KAFKA_SASL_JAAS_CONFIG.getName(),
						"org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"Endpoint=sb://holdingkafka.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=hE42vEvTI4Uqc602lYp+QD26rwNrScUTihA8mOUb/mo=\";"));
			}

			props.put("acks", "all");
			props.put("enable.idempotence", true);
			props.put("key.serializer", StringSerializer.class);
			if (com.temenos.connect.config.Environment.isCloudEvent()) {
				props.put("value.serializer", StringSerializer.class);
			} else {
				props.put("value.serializer", ByteArraySerializer.class);
			}
			props.put("batch.size", 16384);
			props.put("linger.ms", 1);
			props.put("buffer.memory", 33554432);
			return (new com.temenos.des.streamvendorio.kafka.producer.KafkaStreamProducer.Builder())
					.setProperties(props).setClientId(producerClientId).setTransactional(false).producer();
		}
	}
}
