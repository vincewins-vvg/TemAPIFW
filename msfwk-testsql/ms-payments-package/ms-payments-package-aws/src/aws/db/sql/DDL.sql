CREATE TABLE IF NOT EXISTS ms_inbox_events (eventId varchar(255) NOT NULL PRIMARY KEY,eventSourceId varchar(255),eventType varchar(255),organizationId varchar(255), processedTime datetime, priority int, payload longtext, status varchar(255),tenantId varchar(255),userId varchar(255), eventDetails longtext, creationTime datetime,commandType varchar(255));

CREATE TABLE IF NOT EXISTS ms_outbox_events (eventId varchar(255) NOT NULL PRIMARY KEY, eventType varchar(255), correlationId varchar(255), creationTime datetime, eventDetails varchar(255), eventdate datetime, organizationId varchar(255), payload longtext, priority int(11), procesedTime datetime, status varchar(255), tenantId varchar(255), userId varchar(255), processedTime datetime);

DROP PROCEDURE IF EXISTS OUTBOX_PROCEDURE;
CREATE PROCEDURE OUTBOX_PROCEDURE (IN eventId VARCHAR(255),IN eventType varchar(255)) LANGUAGE SQL BEGIN CALL mysql.lambda_async('arn:aws:lambda:eu-west-2:177642146375:function:outbox-sql-handler', CONCAT('{ \"eventId\" : \"', @eventId, '\", \"eventType\" : \"', @eventType, '\"}')); END;

DROP TRIGGER IF EXISTS OUTBOX_TRIGGER;
CREATE TRIGGER OUTBOX_TRIGGER AFTER INSERT ON ms_outbox_events FOR EACH ROW BEGIN SELECT  NEW.eventId, NEW.eventType INTO @eventId, @eventType; CALL OUTBOX_PROCEDURE(@eventId , @eventType); END;

CREATE TABLE IF NOT EXISTS ms_reference_data (type varchar(255), value varchar(255), description varchar(255),  PRIMARY KEY (type, value));
INSERT INTO ms_reference_data(type,value,description) VALUES('paymentref','PayRef','desc');