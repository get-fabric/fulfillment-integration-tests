test_runner_service_name=$1
test_runner_endpoint=$2

pod_name=$(kubectl -n fulfillment get pods --no-headers -o custom-columns=":metadata.name" | grep $test_runner_service_name)

kubectl -n fulfillment port-forward $pod_name 3478:3000 &
sleep 10

echo "calling test runner $test_runner_endpoint endpoint..."
status_code=$(curl --max-time 120 --verbose -LI http://localhost:3478$test_runner_endpoint -o /dev/null -w '%{http_code}\n' -s)
echo "test runner result: $status_code"

if [[ "$status_code" == "200" ]]
    then echo "success"
    exit 0
else
    echo "failure"
    exit 1
fi
