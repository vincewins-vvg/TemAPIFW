@echo on

CALL db/repackbuild.bat ms-paymentorder mongo

CALL install-MongoDB.bat