package com.temenos.microservice.test.producer;

import com.temenos.des.schema.exception.EventSchemaParseException;
import com.temenos.des.serializer.exception.AvroSerializationException;
import com.temenos.des.serializer.exception.SchemaRegistryException;
import com.temenos.des.serializer.serialize.*;
import com.temenos.des.streamprocessor.exception.StreamProducerException;
import com.temenos.des.streamvendorio.core.stream.produce.StreamProducer;
import com.temenos.microservice.framework.core.conf.Environment;
import com.temenos.microservice.framework.core.ingester.IngesterConfigProperty;
import com.temenos.microservice.framework.core.ingester.SchemaRegistryProvider;
import com.temenos.microservice.framework.test.streams.T24EventSchemaProvider;
import org.apache.avro.Schema;
import org.apache.avro.generic.GenericDatumReader;
import org.apache.avro.generic.GenericRecord;
import org.apache.avro.io.*;
import org.apache.kafka.common.serialization.ByteArraySerializer;
import org.apache.kafka.common.serialization.StringSerializer;
import java.io.IOException;
import java.util.Properties;

public class AvroProducer {

    private StreamProducer<byte[]> streamProducer;
    private SchemaRegistry schemaRegistry;
    private AvroSerializer<byte[]> avroSerializer;
    private String streamVendor;
    private String Topic;
    private T24EventSchemaProvider schemaProvider;


    public AvroProducer(String producerName,String localSchemaNamesAsCSVOrRemoteSchemaURL) {
        this.streamVendor = Environment.getEnvironmentVariable
                (IngesterConfigProperty.STREAM_VENDOR.getName(), "kafka");
        schemaProvider = new T24EventSchemaProvider();
        avroSerializer = new AvroBinarySchemaRegistrySerializer(schemaRegistry);
        schemaRegistry = SchemaRegistryProvider.getSchemaRegistry(localSchemaNamesAsCSVOrRemoteSchemaURL);
        streamProducer = ProducerFactory.createStreamProducer(producerName, streamVendor);
        Topic = Environment.getEnvironmentVariable("temn.msf.ingest.sink.stream", "Test-topic");
    }

    private int registerSchema(String schemaName, Schema schema) throws SchemaRegistryException {
        return schemaRegistry.register(schemaName, schema);

    }

    public void sendGenericEvent(String jsonMessage, String applicationName)
            throws IOException, StreamProducerException, InterruptedException, AvroSerializationException, EventSchemaParseException, SchemaRegistryException {
        Schema schema = schemaProvider.getSchema(applicationName).getAvroSchema();
        System.out.println(schema.toString());
        GenericRecord payload = getGenericRecordFromJson(schema, jsonMessage);
        streamProducer.batch().add(Topic,"1", getSerializedMessage
                (getOutgoingConsumerAvro(payload, Topic, registerSchema(applicationName, schema))));
        streamProducer.batch().send();
    }

    public void close() {
        if (streamProducer != null) {
            streamProducer.flush();
            streamProducer.close();
        }
    }

    private OutgoingConsumerAvro getOutgoingConsumerAvro(GenericRecord genericRecord, String topic, Integer schemaRegistryId) {
        return new OutgoingConsumerAvro.Builder()
                .payload(genericRecord).topic(topic).schemaRegistryId(schemaRegistryId).build();
    }

    private byte[] getSerializedMessage(OutgoingConsumerAvro outgoingConsumerAvro) throws AvroSerializationException {
        return avroSerializer.serialize(outgoingConsumerAvro);
    }

    private GenericRecord getGenericRecordFromJson(Schema schema, String input) {
        DatumReader reader = new GenericDatumReader(schema);
        try {
            JsonDecoder decoder = DecoderFactory.get().jsonDecoder(schema, input);
            return (GenericRecord) reader.read(null, decoder);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

}
