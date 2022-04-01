test_runner_service_name=$1
test_runner_endpoint=$2
kubeconigPath=${3:-~/.kube/config}

kubectl --kubeconfig $kubeconigPath -n fulfillment port-forward svc/$test_runner_service_name 3478:80 &
sleep 10

echo "calling test runner $test_runner_endpoint endpoint..."
IFS=$'\n' read -d "" body status_code  < <(curl --max-time 120 -s -w "\n%{http_code}\n" "http://localhost:3478/sanity")
echo "traceId: $body"

if [[ "$status_code" == "200" ]]
    then echo "success"
    exit 0
else
    then echo "failure"
    exit 1
fi
