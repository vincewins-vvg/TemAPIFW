echo "PaymentOrder Party Microservice for deployment slot in Azure"

REM Common configuration details
SET RESOURCE_GROUP_NAME="MSF_2122_paymentorder"
SET LOCATION="uksouth"
SET APP_NAME="paymentorderapp"
SET MSF_NAME="PaymentOrder"
SET SLOT_NAME="greenslot"

az functionapp deployment slot swap -n %APP_NAME% -g %RESOURCE_GROUP_NAME% -s %SLOT_NAME%

echo "PaymentOrder Microservice Swap in Azure Completed"
REM End of Script