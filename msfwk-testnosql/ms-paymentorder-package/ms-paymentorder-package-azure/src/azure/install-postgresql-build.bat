@echo on

CALL db/repackbuild.bat ms-paymentorder postgresql

CALL install-postgresql.bat