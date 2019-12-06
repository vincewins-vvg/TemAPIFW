CREATE TABLE IF NOT EXISTS ms_inbox_events (eventId varchar(255) NOT NULL PRIMARY KEY, eventdate datetime, eventdetails longtext, eventname varchar(255), payload longtext, status varchar(255));
CREATE TABLE IF NOT EXISTS ms_outbox_events (eventId varchar(255) NOT NULL PRIMARY KEY, correlationId varchar(255), creationTime datetime, eventDetails varchar(255), eventdate datetime, eventname varchar(255), organizationId varchar(255), payload longtext, priority int(11), procesedTime datetime, status varchar(255), tenantId varchar(255), userId varchar(255));

DROP PROCEDURE IF EXISTS INBOX_PROCEDURE;
CREATE PROCEDURE INBOX_PROCEDURE (IN eventId VARCHAR(255),IN eventname varchar(255)) LANGUAGE SQL BEGIN CALL mysql.lambda_async('arn:aws:lambda:eu-west-2:177642146375:function:inbox-sql-handler', CONCAT('{ \"eventId\" : \"', @eventId, '\", \"eventname\" : \"', @eventname, '\"}')); END;

DROP PROCEDURE IF EXISTS OUTBOX_PROCEDURE;
CREATE PROCEDURE OUTBOX_PROCEDURE (IN eventId VARCHAR(255),IN eventname varchar(255)) LANGUAGE SQL BEGIN CALL mysql.lambda_async('arn:aws:lambda:eu-west-2:177642146375:function:outbox-sql-handler', CONCAT('{ \"eventId\" : \"', @eventId, '\", \"eventname\" : \"', @eventname, '\"}')); END;

DROP TRIGGER IF EXISTS INBOX_TRIGGER;
CREATE TRIGGER INBOX_TRIGGER AFTER INSERT ON ms_inbox_events FOR EACH ROW BEGIN SELECT  NEW.eventId, NEW.eventname INTO @eventId, @eventname; CALL INBOX_PROCEDURE(@eventId , @eventname); END;

DROP TRIGGER IF EXISTS OUTBOX_TRIGGER;
CREATE TRIGGER OUTBOX_TRIGGER AFTER INSERT ON ms_outbox_events FOR EACH ROW BEGIN SELECT  NEW.eventId, NEW.eventname INTO @eventId, @eventname; CALL OUTBOX_PROCEDURE(@eventId , @eventname); END;