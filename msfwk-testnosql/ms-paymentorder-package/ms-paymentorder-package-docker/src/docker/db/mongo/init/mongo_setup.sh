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
  db.createCollection("ms_payment_order");
EOF
