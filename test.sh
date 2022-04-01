test_runner_service_name=$1
test_runner_endpoint=$2
kubeconigPath=${3:-~/.kube/config}

kubectl --kubeconfig $kubeconigPath -n fulfillment port-forward svc/$test_runner_service_name 3478:80 &
sleep 10

echo "calling test runner $test_runner_endpoint endpoint..."


if [[ "$status_code" == "200" ]]
then
    exit 0
else
    exit 1
fi
