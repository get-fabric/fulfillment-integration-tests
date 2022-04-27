#!/bin/sh

pod_name=${1}
namespace=${2}
kubeconigPath=${3:-~/.kube/config}

result="not_ready"
until [[ -z "$result" ]]
do
    sleep 1
    pod_running=`kubectl --kubeconfig $kubeconigPath get pod $pod_name -n $namespace | grep Running | wc -l`
    echo $pod_running
    if [ $pod_running == "1" ]
    then
        result=`kubectl --kubeconfig $kubeconigPath get pod $pod_name -n $namespace -o=jsonpath='{$.status.containerStatuses[*].ready}' | grep false`
    fi
done
echo "vcluster ready"


