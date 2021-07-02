helm uninstall dbinit -n mongopaymentorder

helm uninstall paymentorder -n paymentorder

kubectl delete namespace mongopaymentorder

kubectl delete namespace paymentorder