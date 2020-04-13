CREATE TYPE IF NOT EXISTS ms_paymentorder.Card (
  cardid bigint,
  cardname text,
  cardlimit decimal,
  extensionData map<text,text>
);


CREATE TABLE IF NOT EXISTS ms_paymentorder.ms_altkey(
alternateKey text
, entityId text
, alternateName text
, PRIMARY KEY(alternateKey));

CREATE TABLE IF NOT EXISTS ms_paymentorder.ms_reference_data(
type text
, value text
, description text
, PRIMARY KEY(type,value));

CREATE TYPE IF NOT EXISTS ms_paymentorder.PaymentMethod (
  id bigint,
  name text,
  card FROZEN<Card>,
  extensionData map<text,text>
);

CREATE TYPE IF NOT EXISTS ms_paymentorder.ExchangeRate (
  id bigint,
  name text,
  value decimal,
  extensionData map<text,text>
);

CREATE TYPE IF NOT EXISTS ms_paymentorder.PayeeDetails (
  payeeId bigint,
  payeeName text,
  payeeType text,
  extensionData map<text,text>
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
, paymentMethod FROZEN<PaymentMethod>
, payeeDetails FROZEN<PayeeDetails>
, extensionData map<text,text>
, fileContent blob
, exchangeRates list<FROZEN <ExchangeRate>>
, PRIMARY KEY (paymentOrderId,debitAccount));

CREATE TABLE IF NOT EXISTS ms_paymentorder.ms_inbox_events(
eventId text
, eventType text
, eventDetails text
, eventSourceId text
, commandType text
, payload text
, creationTime timestamp
, tenantId text
, organizationId text
, userId text
, priority int
, processedTime timestamp
, status text
, PRIMARY KEY (eventId,eventType));

CREATE TABLE IF NOT EXISTS ms_paymentorder.ms_outbox_events(
eventId text
, eventType text
, payload text
, status text
, tenantId text
, organizationId text
, correlationId text
, userId text
, priority int
, eventDetails text
, creationTime timestamp
, processedTime timestamp
, PRIMARY KEY (eventId,eventType));



