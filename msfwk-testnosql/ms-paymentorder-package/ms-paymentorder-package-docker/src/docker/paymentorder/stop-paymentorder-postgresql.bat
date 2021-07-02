helm uninstall dbinit -n postgresqlpaymentorder

helm uninstall paymentorder -n paymentorder

kubectl delete namespace postgresqlpaymentorder

kubectl delete namespace paymentorder