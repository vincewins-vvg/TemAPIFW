CREATE TABLE [ms_payments_accounting]
  (
	accountId			VARCHAR(255) NOT NULL,
	accountHolderName	VARCHAR(255),
	accountType		    VARCHAR(255),
	branch				VARCHAR(255),
	PRIMARY KEY (accountId)
  );
  
CREATE TABLE [ms_payment_order_balance_Transfer]
  (
	recId				VARCHAR(255) NOT NULL,
	stmtProcDate		VARCHAR(255),
	coCode		    	VARCHAR(255),
	onlineClearedBal	DECIMAL(19, 2),
	workingBalance		DECIMAL(19, 2),
	onlineActualBal		DECIMAL(19, 2),
	currency			VARCHAR(255),
	customer 			VARCHAR(255),
	product 			VARCHAR(255),
	processingTime 		DATETIME,
	PRIMARY KEY (recId)
  );  