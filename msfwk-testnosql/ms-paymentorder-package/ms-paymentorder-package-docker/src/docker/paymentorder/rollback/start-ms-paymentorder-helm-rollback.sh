#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

# --------------------------------------------------------------
# - Script to start paymentorder Helm chart Rollback
# --------------------------------------------------------------

echo "Starting the Helm rollback for paymentorder micro service"

helm rollback paymentorder -n paymentorder

sleep 90

echo "Rollback to previous version of deployment completed"