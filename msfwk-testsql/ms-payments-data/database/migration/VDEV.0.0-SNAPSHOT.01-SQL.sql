ALTER TABLE Balance
ADD
	txnReference		VARCHAR(255)
;
ALTER TABLE Card ADD INDEX (cardname);
ALTER TABLE ms_payment_order
ADD
	paymentTxnRef		VARCHAR(255)
;
ALTER TABLE ms_payment_order ADD INDEX (paymentTxnRef);
CREATE TABLE TransactionBalance
  (
		recId		VARCHAR(255) NOT NULL,
		stmtProcDate		VARCHAR(255),
		coCode		VARCHAR(255),
		onlineClearedBal		DECIMAL(19, 2),
		workingBalance		DECIMAL(19, 2),
		onlineActualBal		DECIMAL(19, 2),
		currency		VARCHAR(255),
		customer		VARCHAR(255),
		product		VARCHAR(255),
		processingTime		TIMESTAMP,
		txnReference		VARCHAR(255),
	PRIMARY KEY (recId)
  );
CREATE TABLE TxnBalance_extension
  (
     balance_recid		VARCHAR(255) NOT NULL,	
     value		VARCHAR(255),	
     name		VARCHAR(255) NOT NULL,     
     PRIMARY KEY (name, balance_recid)
  );
CREATE TABLE PaymentTransaction
  (
		recId		VARCHAR(255) NOT NULL,
		companyCode		VARCHAR(255),
		amountLcy		VARCHAR(255),
		processingDate		TIMESTAMP,
		transactionCode		VARCHAR(255),
		valueDate		TIMESTAMP,
		accountNumber		INTEGER,
		ourReference		VARCHAR(255),
		theirReference		VARCHAR(255),
		accountOfficer		VARCHAR(255),
		transReference		VARCHAR(255),
		bookingDate		TIMESTAMP,
		customerId		VARCHAR(255),
		currency		VARCHAR(255),
	PRIMARY KEY (recId)
  );
CREATE TABLE PaymentTransaction_extension
  (
     transaction_recid		VARCHAR(255) NOT NULL,	
     value		VARCHAR(255),	
     name		VARCHAR(255) NOT NULL,     
     PRIMARY KEY (name, transaction_recid)
  );
ALTER TABLE TransactionBalance ADD INDEX (recid);
ALTER TABLE PaymentTransaction ADD INDEX (recid);
ALTER TABLE TxnBalance_extension
  ADD CONSTRAINT FOREIGN KEY (
  balance_recid) REFERENCES TransactionBalance (  recId );
ALTER TABLE PaymentTransaction_extension
  ADD CONSTRAINT FOREIGN KEY (
  transaction_recid) REFERENCES PaymentTransaction (  recId );
