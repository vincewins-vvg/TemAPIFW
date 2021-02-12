@echo off
REM --------------------------------------------------------------
REM - Script to stop Paymentorder Service
REM --------------------------------------------------------------

REM - Build paymentorder images


helm uninstall ponosql


cd db

call stop-podb-scripts.bat

cd ../