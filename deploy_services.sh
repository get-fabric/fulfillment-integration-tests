kubectl create namespace job-management
kubectl create namespace fulfillment

kubectl apply -n default -f ./deployments/default/mongo.yaml
kubectl apply -n default -f ./deployments/default/kafka.yaml

kubectl apply -n job-management -f ./deployments/job-management/station-api.yaml
kubectl apply -n fulfillment -f ./deployments/fulfillment/apply-mode-change.yaml
kubectl apply -n fulfillment -f ./deployments/fulfillment/insert-totes-allocator.yaml
kubectl apply -n fulfillment -f ./deployments/fulfillment/allocation-api.yaml
kubectl apply -n fulfillment -f ./deployments/fulfillment/request-totes.yaml
kubectl apply -n fulfillment -f ./deployments/fulfillment/motion-api.yaml
kubectl apply -n fulfillment -f ./deployments/fulfillment/motion-mock.yaml
kubectl apply -n fulfillment -f ./deployments/fulfillment/insert-totes.yaml
kubectl apply -n fulfillment -f ./deployments/fulfillment/reply-mock.yaml
kubectl apply -n fulfillment -f ./deployments/fulfillment/wms-api.yaml
kubectl apply -n fulfillment -f ./deployments/fulfillment/integration-test-runner.yaml