package com.temenos.microservice.payments.ingester.test;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.sql.SQLException;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;
import java.util.Random;

import org.apache.kafka.clients.admin.AdminClient;
import org.apache.kafka.clients.admin.DeleteTopicsResult;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.serialization.ByteArrayDeserializer;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.junit.Before;
import org.junit.FixMethodOrder;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runners.MethodSorters;
import org.springframework.http.HttpStatus;
import org.springframework.web.reactive.function.client.ClientResponse;

import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.kafka.util.KafkaStreamProducer;
import com.temenos.microservice.payments.api.test.ITTest;

@Ignore
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class StateIngesterItTest extends ITTest {

	private KafkaConsumer<String, byte[]> kafkaConsmer;

	String businessTopic = "";

	String bootstrapServers = "kafka:29092";

	@Before
	public void setUp() throws SQLException {
		this.client = newWebClient();
	}

	@Test
	public void AtestConsumerLag() {
		if ("kafka".equals(Environment.getEnvironmentVariable("temn.msf.stream.vendor", ""))) {
			businessTopic = Environment.getEnvironmentVariable("temn.msf.ingest.source.stream.business",
					"table-update-business");
			bootstrapServers = Environment.getEnvironmentVariable("temn.msf.stream.kafka.bootstrap.servers",
					"kafka:29092");
			List<byte[]> messageList = new ArrayList<>();
			messageList.add(new String("1").getBytes());
			messageList.add(new String("2").getBytes());
			messageList.add(new String("3").getBytes());
			messageList.add(new String("4").getBytes());
			KafkaStreamProducer.postMessageToTopic(businessTopic, messageList);
			try {
				ClientResponse getResponse;
				do {
					getResponse = this.client.get().uri("/payments/orders/invoke?paymentStateId=prep").exchange()
							.block();
				} while (getResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
				
				Properties props = new Properties();
				props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
				props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
				props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, ByteArrayDeserializer.class);
				Random r = new Random();
				props.put(ConsumerConfig.GROUP_ID_CONFIG, "testGroupId"+ r.nextInt());
				props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
				this.kafkaConsmer = new KafkaConsumer<String, byte[]>(props);
				this.kafkaConsmer.subscribe(Arrays.asList("table-result"));
				String resultFlags = "";
				Thread.sleep(10000);
				for (int i = 0; i < 10; i++) {
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
				List<String> deleteTopicsList = new ArrayList<>();
				deleteTopicsList.add("table-result");
				deleteTopicsList.add(businessTopic);
				deleteTopicsList.add("table-update-state");
				DeleteTopicsResult delTopicResult = adminClient.deleteTopics(deleteTopicsList);
				adminClient.close();
				assertTrue(resultFlags.equals("success"));
			} catch (Exception e) {
				org.junit.Assert.fail(e.getMessage());
			}
		}
	}

	@Test
	public void BtestConsumerLag() {
		if ("kafka".equals(Environment.getEnvironmentVariable("temn.msf.stream.vendor", ""))) {
			businessTopic = Environment.getEnvironmentVariable("temn.msf.ingest.source.stream.business",
					"table-update-business");
			bootstrapServers = Environment.getEnvironmentVariable("temn.msf.stream.kafka.bootstrap.servers",
					"kafka:29092");
			try {
				ClientResponse getResponse;
				do {
					getResponse = this.client.get().uri("/payments/orders/invoke?paymentStateId=prep").exchange()
							.block();
				} while (getResponse.statusCode().equals(HttpStatus.GATEWAY_TIMEOUT));
				List<byte[]> messageList = new ArrayList<>();
				for (int i = 0; i < 50; i++) {
					messageList.add(String.valueOf(i).getBytes());
				}
				KafkaStreamProducer.postMessageToTopic(businessTopic, messageList);
				Properties props = new Properties();
				props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "kafka:29092");
				props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
				props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, ByteArrayDeserializer.class);
				props.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");
				Random r = new Random();
				props.put(ConsumerConfig.GROUP_ID_CONFIG, "testGroupId" + r.nextInt());
				props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
				this.kafkaConsmer = new KafkaConsumer<String, byte[]>(props);
				this.kafkaConsmer.subscribe(Arrays.asList("table-result"));
				String resultFlags = "";
				Thread.sleep(10000);
				for (int i = 0; i < 10; i++) {
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
				properties.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");
				AdminClient adminClient = AdminClient.create(props);
				List<String> deleteTopicsList = new ArrayList<>();
				deleteTopicsList.add("table-result");
				deleteTopicsList.add(businessTopic);
				deleteTopicsList.add("table-update-state");
				adminClient.deleteConsumerGroups(Arrays.asList("msf-test-group-id"));
				adminClient.deleteTopics(deleteTopicsList);
				adminClient.close();
				System.out.println("Result for StateIngesterItTest.BtestConsumerLag::" + resultFlags);
				assertTrue(resultFlags.equals("failure"));
			} catch (Exception e) {
				org.junit.Assert.fail(e.getMessage());
			}
		}
	}
}
