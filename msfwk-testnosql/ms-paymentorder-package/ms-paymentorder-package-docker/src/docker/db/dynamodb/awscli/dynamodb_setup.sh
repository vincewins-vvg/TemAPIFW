#!/bin/bash
echo "sleeping for 10 before initiating replica set"
sleep 10

echo dynamodb_setup.sh time now: `date +"%T" `

# Setup the environment
export AWS_ACCESS_KEY_ID="fakeMyKeyId"
export AWS_SECRET_ACCESS_KEY="fakeSecretAccessKey"
export AWS_REGION=eu-west-2
export AWS_DEFAULT_OUTPUT="json"

# Create tables
aws dynamodb create-table  --region eu-west-2 --table-name PaymentOrder.ms_inbox_events --attribute-definitions AttributeName=eventId,AttributeType=S AttributeName=eventType,AttributeType=S --key-schema AttributeName=eventId,KeyType=HASH  AttributeName=eventType,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --endpoint-url http://ms-paymentorder-dynamodb:8000

aws dynamodb create-table --table-name --region eu-west-2 ms_payment_order --attribute-definitions AttributeName=paymentOrderId,AttributeType=S AttributeName=debitAccount,AttributeType=S --key-schema AttributeName=paymentOrderId,KeyType=HASH  AttributeName=debitAccount,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --endpoint-url http://ms-paymentorder-dynamodb:8000

aws dynamodb create-table --table-name --region eu-west-2 ms_payment_order_customer --attribute-definitions AttributeName=customerId,AttributeType=S AttributeName=customerName,AttributeType=S --key-schema AttributeName=customerId,KeyType=HASH  AttributeName=customerName,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --endpoint-url http://ms-paymentorder-dynamodb:8000

aws dynamodb create-table --table-name --region eu-west-2 PaymentOrder.ms_outbox_events --attribute-definitions AttributeName=eventId,AttributeType=S AttributeName=eventType,AttributeType=S --key-schema AttributeName=eventId,KeyType=HASH  AttributeName=eventType,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --endpoint-url http://ms-paymentorder-dynamodb:8000
sleep 5

aws dynamodb create-table --table-name --region eu-west-2 ms_file_upload --attribute-definitions AttributeName=name,AttributeType=S AttributeName=mimetype,AttributeType=S --key-schema AttributeName=name,KeyType=HASH  AttributeName=mimetype,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --endpoint-url http://ms-paymentorder-dynamodb:8000
sleep 5

aws dynamodb create-table \
     --table-name --region eu-west-2 ms_reference_data \
     --attribute-definitions \
         AttributeName=type,AttributeType=S \
         AttributeName=value,AttributeType=S \
     --key-schema AttributeName=type,KeyType=HASH AttributeName=value,KeyType=RANGE \
     --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --endpoint-url http://ms-paymentorder-dynamodb:8000

sleep 5

#Add reference Data
aws dynamodb put-item --table-name ms_reference_data --item '{ "type": {"S": "paymentref" }, "value": {"S": "PayRef" }, "description": {"S": "Payment Reference" }}' --endpoint-url http://ms-paymentorder-dynamodb:8000

aws dynamodb put-item --table-name ms_reference_data --item '{ "type": {"S": "paymentref" }, "value": {"S": "paytest" }, "description": {"S": "Payment Reference" }}' --endpoint-url http://ms-paymentorder-dynamodb:8000

aws dynamodb put-item --table-name ms_reference_data --item '{ "type": {"S": "paymentref" }, "value": {"S": "payiop" }, "description": {"S": "Payment Reference" }}' --endpoint-url http://ms-paymentorder-dynamodb:8000

aws dynamodb put-item --table-name ms_reference_data --item '{ "type": {"S": "paymentref" }, "value": {"S": "payiobg" }, "description": {"S": "Payment Reference" }}' --endpoint-url http://ms-paymentorder-dynamodb:8000

aws dynamodb put-item --table-name ms_reference_data --item '{ "type": {"S": "paymentref" }, "value": {"S": "paycmd" }, "description": {"S": "Payment Reference" }}' --endpoint-url http://ms-paymentorder-dynamodb:8000

aws dynamodb put-item --table-name ms_reference_data --item '{ "type": {"S": "paymentref" }, "value": {"S": "paytest11" }, "description": {"S": "Payment Reference" }}' --endpoint-url http://ms-paymentorder-dynamodb:8000

aws dynamodb put-item --table-name ms_reference_data --item '{ "type": {"S": "paymentref" }, "value": {"S": "cloudstorage" }, "description": {"S": "Payment Reference" }}' --endpoint-url http://ms-paymentorder-dynamodb:8000

aws dynamodb put-item --table-name ms_reference_data --item '{ "type": {"S": "paymentref" }, "value": {"S": "payeven" }, "description": {"S": "Payment Reference" }}' --endpoint-url http://ms-paymentorder-dynamodb:8000

sleep 10;

echo "Completed the addition of data"

# aws dynamodb list-tables --endpoint-url http://ms-paymentorder-dynamodb:8000

echo dynamodb_setup.sh time now: `date +"%T" `
sleep 10000
