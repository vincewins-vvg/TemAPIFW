ALTER TABLE ms_payment_order
  ADD txn_ref varchar(50);
 
CREATE INDEX paymentDetails_index ON ms_payment_order (paymentDetails);