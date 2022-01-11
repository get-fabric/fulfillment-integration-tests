set -e
kubectl delete -n default -f ./deployments/default/mongo.yaml
kubectl delete -n default -f ./deployments/default/kafka.yaml
kubectl delete -n job-management -f ./deployments/job-management
kubectl delete -n fulfillment -f ./deployments/fulfillment
