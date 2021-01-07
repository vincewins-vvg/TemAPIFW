#!/bin/bash
echo "sleeping for 10 before initiating  replica set"
sleep 10

echo mongo_setup.sh time now: `date +"%T" `
mongo --host mongo1:27017 <<EOF  
  var cfg = {
    "_id": "ms-mongo-set",
    "version": 1,
    "members": [
      {
        "_id": 0,
        "host": "mongo1:27017",
        "priority": 2
      },
      {
        "_id": 1,
        "host": "mongo2:27017",
        "priority": 0
      },
      {
        "_id": 2,
        "host": "mongo3:27017",
        "priority": 0
      }
    ]
  };
  rs.initiate(cfg);
EOF

echo "sleeping for 30 seconds before creating database and collection"
sleep 30

mongo --host mongo1:27017 <<EOF
  rs.status();
  use ms_paymentorder
  db.createUser(
    {
	  user: "root",
	  pwd: "root",  
	  roles: [
	     { role: "readWrite", db: "ms_paymentorder" }
	  ]
    }
  );
  db.createCollection("ms_payment_order");
  db.createCollection("ms_inbox_events");
  db.createCollection("ms_outbox_events");
  db.createCollection("ms_reference_data");
  db.createCollection("ms_altkey");
  db.createCollection("ms_file_upload");
  db.createCollection("ms_payments_user");
  db.createCollection("ms_payments_account"); 
  db.createCollection("ms_payment_order_customer");
  db.ms_payment_order_customer.createIndex( { "customerId": 1 }, { unique: true } )
  db.createCollection("ms_payment_order_balance");
  db.createCollection("ms_payment_order_transaction");
EOF
