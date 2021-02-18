export mongo_path={{ mongo_path }}/bin
export PATH=$PATH:$mongo_path
export DB_NAME="ms_paymentorder"
export MONGO_CONNECTIONSTR=mongodb+srv://badri0307:badri0307@mongodb01.qjebf.azure.mongodb.net

mongo $MONGO_CONNECTIONSTR <<EOF
  rs.status();
  use $DB_NAME
  db.createUser(
    {
      user: "root",
      pwd: "root",  
      roles: [
         { role: "readWrite", db: "$DB_NAME" }
      ]
    }
  );
  db.createCollection("ms_payment_order");
  db.createCollection("ms_inbox_events");
  db.createCollection("ms_outbox_events");
  db.createCollection("ms_file_upload");
  db.createCollection("ms_payments_user");
  db.createCollection("ms_payments_account"); 
  db.createCollection("ms_payment_order_customer");
  db.ms_payment_order_customer.createIndex( { "customerId": 1 }, { unique: true } )
  db.createCollection("ms_payment_order_balance");
  db.createCollection("ms_payment_order_transaction");
EOF