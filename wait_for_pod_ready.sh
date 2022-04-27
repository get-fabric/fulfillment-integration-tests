#!/bin/sh

pod_name=${1}
namespace=${2}

result="not_ready"
until [[ -z "$result" ]]
do
sleep 5
result=`kubectl get pod $pod_name -n $namespace -o=jsonpath='{$.status.containerStatuses[*].ready}' | grep false`
done

