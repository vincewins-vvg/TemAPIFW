--
-- *******************************************************************************
-- * Copyright © Temenos Headquarters SA 2021. All rights reserved.
-- *******************************************************************************
--

CREATE TABLE IF NOT EXISTS ms_payment_order ( data jsonb );
CREATE TABLE IF NOT EXISTS ms_inbox_events ( data jsonb );
CREATE TABLE IF NOT EXISTS ms_outbox_events ( data jsonb );
CREATE TABLE IF NOT EXISTS ms_reference_data ( data jsonb );
CREATE TABLE IF NOT EXISTS ms_altkey ( data jsonb );
CREATE TABLE IF NOT EXISTS ms_file_upload ( data jsonb );
CREATE TABLE IF NOT EXISTS ms_payments_user ( data jsonb );
CREATE TABLE IF NOT EXISTS ms_payments_account ( data jsonb );
CREATE TABLE IF NOT EXISTS ms_payment_order_customer ( data jsonb );
CREATE TABLE IF NOT EXISTS ms_payment_order_balance ( data jsonb );
CREATE TABLE IF NOT EXISTS ms_payment_order_transaction ( data jsonb );
CREATE TABLE IF NOT EXISTS ms_error ( data jsonb );

CREATE UNIQUE INDEX IF NOT EXISTS msaltkey ON ms_altkey ((data->'alternateKey'), (data->'alternateName'));
CREATE UNIQUE INDEX IF NOT EXISTS msreftypevalue ON ms_reference_data ((data->'type'), (data->'value'));
CREATE UNIQUE INDEX IF NOT EXISTS msinboxidtype ON ms_inbox_events ((data->'eventId'), (data->'eventType'));
CREATE UNIQUE INDEX IF NOT EXISTS msoutboxidtype ON ms_outbox_events ((data->'eventId'), (data->'eventType'));
CREATE UNIQUE INDEX IF NOT EXISTS mspayaccount ON ms_payments_account ((data->'accountId'));
CREATE UNIQUE INDEX IF NOT EXISTS mspobalance ON ms_payment_order_balance ((data->'recId'));
CREATE UNIQUE INDEX IF NOT EXISTS msfileupload ON ms_file_upload ((data->'name'));
CREATE UNIQUE INDEX IF NOT EXISTS mspotransaction ON ms_payment_order_transaction ((data->'recId'));
CREATE UNIQUE INDEX IF NOT EXISTS mspayuser ON ms_payments_user ((data->'userId'));
CREATE UNIQUE INDEX IF NOT EXISTS mspopayiddebitacc ON ms_payment_order ((data->'paymentOrderId'), (data->'debitAccount'));
CREATE UNIQUE INDEX IF NOT EXISTS mspocusidcusname ON ms_payment_order_customer ((data->'customerId'), (data->'customerName'));
