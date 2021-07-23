helm uninstall appinit -n appinitpayments

helm uninstall dbinit -n dbinitpayments

helm uninstall payments -n payments

kubectl delete namespace appinitpayments

kubectl delete namespace dbinitpayments

kubectl delete namespace payments