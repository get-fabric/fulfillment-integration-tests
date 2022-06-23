#!/bin/sh

pod_name=${1}
namespace=${2}

result="not_ready"
until [[ -z "$result" ]]
do
    sleep 1
    pod_running=`kubectl get pod $pod_name -n $namespace | grep Running | wc -l`
    if [ $pod_running == "1" ]
    then
        result=`kubectl get pod $pod_name -n $namespace -o=jsonpath='{$.status.containerStatuses[*].ready}' | grep false`
    fi
done
echo "vcluster ready"