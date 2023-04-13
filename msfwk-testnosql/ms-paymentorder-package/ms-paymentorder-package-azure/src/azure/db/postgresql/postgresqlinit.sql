
CREATE UNIQUE INDEX msaltkey ON ms_altkey ((data->'alternateKey'), (data->'alternateName'));
CREATE UNIQUE INDEX msreftypevalue ON ms_reference_data ((data->'type'), (data->'value'));
CREATE UNIQUE INDEX msinboxidtype ON ms_inbox_events ((data->'eventId'), (data->'eventType'));
CREATE UNIQUE INDEX msoutboxidtype ON ms_outbox_events ((data->'eventId'), (data->'eventType'));
CREATE UNIQUE INDEX mspayaccount ON ms_payments_account ((data->'accountId'));
CREATE UNIQUE INDEX mspobalance ON ms_payment_order_balance ((data->'recId'));
CREATE UNIQUE INDEX msfileupload ON ms_file_upload ((data->'name'));
CREATE UNIQUE INDEX mspotransaction ON ms_payment_order_transaction ((data->'recId'));
CREATE UNIQUE INDEX mspayuser ON ms_payments_user ((data->'userId'));
CREATE UNIQUE INDEX mspopayiddebitacc ON ms_payment_order ((data->'paymentOrderId'), (data->'debitAccount'));
CREATE UNIQUE INDEX mspocusidcusname ON ms_payment_order_customer ((data->'customerId'), (data->'customerName'));
CREATE UNIQUE INDEX msauitreqid ON ms_audit_log ((data->'requestId'), (data->'userId'));