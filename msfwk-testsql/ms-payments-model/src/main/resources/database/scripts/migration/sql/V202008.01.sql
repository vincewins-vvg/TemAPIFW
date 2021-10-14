ALTER TABLE ms_payment_order
  ADD txn_ref varchar(50);
  
ALTER TABLE ms_payment_order ADD INDEX paymentDetails_index (paymentDetails);
