package com.temenos.microservice.payments.ingester.test;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.time.Duration;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;
import java.util.Random;

import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.kafka.clients.admin.AdminClient;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.serialization.ByteArrayDeserializer;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.junit.Test;

import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.kafka.util.KafkaStreamProducer;

public class StateIngesterItTest {

	private KafkaConsumer<String, byte[]> kafkaConsmer;

	String businessTopic = "";

	String bootstrapServers = "";

	@Test
	public void testNoConsumerLag() {
		businessTopic = Environment.getEnvironmentVariable("temn.msf.ingest.source.stream", "table-update-business");
		bootstrapServers = Environment.getEnvironmentVariable("temn.msf.stream.kafka.bootstrap.servers", "kafka:29092");
		List<byte[]> messageList = new ArrayList<>();
		messageList.add(new String("1").getBytes());
		messageList.add(new String("2").getBytes());
		messageList.add(new String("3").getBytes());
		messageList.add(new String("4").getBytes());
		messageList.add(new String("5").getBytes());
		KafkaStreamProducer.postMessageToTopic(businessTopic, messageList);
		String url = "http://localhost:8090/ms-payments-api/api/payments/orders/invoke";
		try {
			URIBuilder builder = new URIBuilder(url);
			builder.setParameter("paymentStateId", "prep");
			CloseableHttpClient httpClient = HttpClientBuilder.create().build();
			HttpGet getRequest = new HttpGet(builder.build());
			httpClient.execute(getRequest);
			Thread.sleep(20000);
			Properties props = new Properties();
			props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
			props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
			props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, ByteArrayDeserializer.class);
			Random r = new Random();
			props.put(ConsumerConfig.GROUP_ID_CONFIG, "testGroupId" + r.nextInt());
			props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
			this.kafkaConsmer = new KafkaConsumer<String, byte[]>(props);
			this.kafkaConsmer.subscribe(Arrays.asList("table-result"));
			String resultFlags = "false";
			while (true) {
				ConsumerRecords<String, byte[]> records = this.kafkaConsmer.poll(Duration.ofMillis(1000));
				if (records.count() == 1) {
					resultFlags = new String(records.iterator().next().value());
					break;
				}
			}
			this.kafkaConsmer.close();
			Properties properties = new Properties();
			properties.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "kafka:29092");
			properties.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
			properties.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, ByteArrayDeserializer.class);
			AdminClient adminClient = AdminClient.create(props);
			adminClient.deleteTopics(Arrays.asList("table-result", businessTopic));
			adminClient.close();
			assertTrue(Boolean.valueOf(resultFlags));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Test
	public void testConsumerLag() {
		businessTopic = Environment.getEnvironmentVariable("temn.msf.ingest.source.stream", "table-update-business");
		bootstrapServers = Environment.getEnvironmentVariable("temn.msf.stream.kafka.bootstrap.servers", "kafka:29092");
		String url = "http://localhost:8090/ms-payments-api/api/payments/orders/invoke";
		try {
			URIBuilder builder = new URIBuilder(url);
			builder.setParameter("paymentStateId", "prep");
			CloseableHttpClient httpClient = HttpClientBuilder.create().build();
			HttpGet getRequest = new HttpGet(builder.build());
			httpClient.execute(getRequest);
			List<byte[]> messageList = new ArrayList<>();
			messageList.add(new String("1").getBytes());
			messageList.add(new String("2").getBytes());
			messageList.add(new String("3").getBytes());
			messageList.add(new String("4").getBytes());
			messageList.add(new String("5").getBytes());
			messageList.add(new String("45").getBytes());
			messageList.add(new String("s2").getBytes());
			messageList.add(new String("3s").getBytes());
			messageList.add(new String("4d").getBytes());
			messageList.add(new String("5s").getBytes());
			messageList.add(new String("1s").getBytes());
			messageList.add(new String("2s").getBytes());
			messageList.add(new String("3s").getBytes());
			messageList.add(new String("4s").getBytes());
			messageList.add(new String("5s").getBytes());
			messageList.add(new String("1s").getBytes());
			messageList.add(new String("2s").getBytes());
			messageList.add(new String("3s").getBytes());
			messageList.add(new String("4s").getBytes());
			messageList.add(new String("5s").getBytes());
			messageList.add(new String("1s").getBytes());
			messageList.add(new String("2s").getBytes());
			messageList.add(new String("3s").getBytes());
			messageList.add(new String("4s").getBytes());
			messageList.add(new String("5s").getBytes());
			KafkaStreamProducer.postMessageToTopic(businessTopic, messageList);
			Properties props = new Properties();
			props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "kafka:29092");
			props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
			props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, ByteArrayDeserializer.class);
			Random r = new Random();
			props.put(ConsumerConfig.GROUP_ID_CONFIG, "testGroupId" + r.nextInt());
			props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
			this.kafkaConsmer = new KafkaConsumer<String, byte[]>(props);
			this.kafkaConsmer.subscribe(Arrays.asList("table-result"));
			String resultFlags = "false";
			while (true) {
				ConsumerRecords<String, byte[]> records = this.kafkaConsmer.poll(Duration.ofMillis(1000));
				if (records.count() == 1) {
					resultFlags = new String(records.iterator().next().value());
					break;
				}
			}
			this.kafkaConsmer.close();
			Properties properties = new Properties();
			properties.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "kafka:29092");
			properties.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
			properties.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, ByteArrayDeserializer.class);
			AdminClient adminClient = AdminClient.create(props);
			adminClient.deleteTopics(Arrays.asList("table-result", businessTopic));
			adminClient.close();
			assertFalse(Boolean.valueOf(resultFlags));
		} catch (Exception e) {
			e.printStackTrace();

		}
	}
}
