ALTER TABLE Balance
ADD
	txnReference		VARCHAR(255)
;
CREATE UNIQUE INDEX a0c6ac7310d6a42fa863ccdd3d8169dac 
ON Card (cardname);
ALTER TABLE ms_payment_order
ADD
	paymentTxnRef		VARCHAR(255)
;
CREATE UNIQUE INDEX a328327a8957c4b88aba2ca9f9e6a995b 
ON ms_payment_order (paymentTxnRef);
CREATE TABLE TransactionBalance
  (
		recId		VARCHAR2(255 CHAR) NOT NULL,
		stmtProcDate		VARCHAR2(255 CHAR),
		coCode		VARCHAR2(255 CHAR),
		onlineClearedBal		FLOAT(126),
		workingBalance		FLOAT(126),
		onlineActualBal		FLOAT(126),
		currency		VARCHAR2(255 CHAR),
		customer		VARCHAR2(255 CHAR),
		product		VARCHAR2(255 CHAR),
		processingTime		TIMESTAMP(6),
		txnReference		VARCHAR2(255 CHAR),
	PRIMARY KEY (recId)
  );
CREATE TABLE TxnBalance_extension
  (
     balance_recid		VARCHAR2(255 CHAR) NOT NULL,	
     value		VARCHAR(255),	
     name		VARCHAR2(255 CHAR) NOT NULL,     
     PRIMARY KEY (name, balance_recid)
  );
CREATE TABLE PaymentTransaction
  (
		recId		VARCHAR2(255 CHAR) NOT NULL,
		companyCode		VARCHAR2(255 CHAR),
		amountLcy		VARCHAR2(255 CHAR),
		processingDate		TIMESTAMP(6),
		transactionCode		VARCHAR2(255 CHAR),
		valueDate		TIMESTAMP(6),
		accountNumber		NUMBER(10),
		ourReference		VARCHAR2(255 CHAR),
		theirReference		VARCHAR2(255 CHAR),
		accountOfficer		VARCHAR2(255 CHAR),
		transReference		VARCHAR2(255 CHAR),
		bookingDate		TIMESTAMP(6),
		customerId		VARCHAR2(255 CHAR),
		currency		VARCHAR2(255 CHAR),
	PRIMARY KEY (recId)
  );
CREATE TABLE PaymentTransaction_extension
  (
     transaction_recid		VARCHAR2(255 CHAR) NOT NULL,	
     value		VARCHAR(255),	
     name		VARCHAR2(255 CHAR) NOT NULL,     
     PRIMARY KEY (name, transaction_recid)
  );
ALTER TABLE TxnBalance_extension
  ADD CONSTRAINT balance_recid_transactionbalance FOREIGN KEY (
  balance_recid) REFERENCES TransactionBalance (  recId );
ALTER TABLE PaymentTransaction_extension
  ADD CONSTRAINT transaction_recid_paymenttransaction FOREIGN KEY (
  transaction_recid) REFERENCES PaymentTransaction (  recId );
