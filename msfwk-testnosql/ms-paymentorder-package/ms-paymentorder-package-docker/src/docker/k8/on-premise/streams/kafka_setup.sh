#!/usr/bin/env bash
#
# *******************************************************************************
# * Copyright © Temenos Headquarters SA 2021. All rights reserved.
# *******************************************************************************
#

set -e
# Turn colors in this script off by setting the NO_COLOR variable in your
# environment to any value:
#
# $ NO_COLOR=1 test.sh
NO_COLOR=${NO_COLOR:-""}
if [ -z "$NO_COLOR" ]; then
  header=$'\e[1;33m'
  reset=$'\e[0m'
else
  header=''
  reset=''
fi
function header_text {
  echo "$header$*$reset"
}
header_text "Strimzi install"
kubectl create namespace kafka
curl -L "https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.27.0/strimzi-cluster-operator-0.27.0.yaml" \
  | sed 's/namespace: .*/namespace: kafka/' \
  | kubectl -n kafka apply -f -
header_text "Applying Strimzi Cluster file"