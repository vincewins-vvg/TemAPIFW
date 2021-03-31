#!/bin/bash -x

./repackbuild.sh ms-paymentorder postgresql
./install-postgresql-aws.sh