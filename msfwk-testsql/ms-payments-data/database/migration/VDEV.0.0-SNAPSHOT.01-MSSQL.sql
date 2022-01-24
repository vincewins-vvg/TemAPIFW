ALTER TABLE [Balance]
ADD
	txnReference		VARCHAR(255)
;
CREATE UNIQUE INDEX a0c6ac7310d6a42fa863ccdd3d8169dac 
ON [Card] (cardname);
ALTER TABLE [ms_payment_order]
ADD
	paymentTxnRef		VARCHAR(255)
;
CREATE UNIQUE INDEX a328327a8957c4b88aba2ca9f9e6a995b 
ON [ms_payment_order] (paymentTxnRef);
CREATE TABLE [TransactionBalance]
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
		processingTime		DATETIME,
		txnReference		VARCHAR(255),
	PRIMARY KEY (recId)
  );
CREATE TABLE [TxnBalance_extension]
  (
     balance_recid		VARCHAR(255) NOT NULL,	
     value		VARCHAR(255),	
     name		VARCHAR(255) NOT NULL,     
     PRIMARY KEY (name, balance_recid)
  );
CREATE TABLE [PaymentTransaction]
  (
		recId		VARCHAR(255) NOT NULL,
		companyCode		VARCHAR(255),
		amountLcy		VARCHAR(255),
		processingDate		DATETIME,
		transactionCode		VARCHAR(255),
		valueDate		DATETIME,
		accountNumber		INTEGER,
		ourReference		VARCHAR(255),
		theirReference		VARCHAR(255),
		accountOfficer		VARCHAR(255),
		transReference		VARCHAR(255),
		bookingDate		DATETIME,
		customerId		VARCHAR(255),
		currency		VARCHAR(255),
	PRIMARY KEY (recId)
  );
CREATE TABLE [PaymentTransaction_extension]
  (
     transaction_recid		VARCHAR(255) NOT NULL,	
     value		VARCHAR(255),	
     name		VARCHAR(255) NOT NULL,     
     PRIMARY KEY (name, transaction_recid)
  );
CREATE UNIQUE INDEX recid_TransactionBalance
ON [TransactionBalance] (recid);
CREATE UNIQUE INDEX recid_PaymentTransaction
ON [PaymentTransaction] (recid);
ALTER TABLE [TxnBalance_extension]
  ADD CONSTRAINT balance_recid_transactionbalance FOREIGN KEY (
  balance_recid) REFERENCES [TransactionBalance] (  recId );
ALTER TABLE [PaymentTransaction_extension]
  ADD CONSTRAINT transaction_recid_paymenttransaction FOREIGN KEY (
  transaction_recid) REFERENCES [PaymentTransaction] (  recId );
