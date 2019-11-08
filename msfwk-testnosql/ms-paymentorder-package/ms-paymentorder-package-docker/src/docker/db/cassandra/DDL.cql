CREATE TYPE IF NOT EXISTS ms_paymentorder.Card (
  cardid bigint,
  cardname text,
  cardlimit decimal
);

CREATE TYPE IF NOT EXISTS ms_paymentorder.PaymentMethod (
  id bigint,
  name text,
  card FROZEN<Card>
);

CREATE TYPE IF NOT EXISTS ms_paymentorder.ExchangeRate (
  id bigint,
  name text,
  value decimal
);

CREATE TYPE IF NOT EXISTS ms_paymentorder.PayeeDetails (
  payeeId bigint,
  payeeName text,
  payeeType text
);

CREATE TABLE IF NOT EXISTS ms_paymentorder.ms_payment_order(
paymentOrderId text
, debitAccount text
, creditAccount text
, paymentReference text
, paymentDetails text
, paymentDate timestamp
, amount decimal
, currency text
, status text
, paymentMethod PaymentMethod
, payeeDetails PayeeDetails
, extensionData map<text,text>
, exchangeRates list<FROZEN <ExchangeRate>>
, PRIMARY KEY (paymentOrderId,debitAccount));

CREATE TABLE IF NOT EXISTS ms_paymentorder.ms_inbox_events(
eventId text
, eventname text
, eventdetails text
, payload text
, eventdate timestamp
, status text
, PRIMARY KEY (eventId,eventname));

CREATE TABLE IF NOT EXISTS ms_paymentorder.ms_outbox_events(
eventId text
, eventname text
, payload text
, eventdate timestamp
, status text
, PRIMARY KEY (eventId,eventname));