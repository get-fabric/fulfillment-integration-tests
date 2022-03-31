#!/bin/sh

vclusterName=$1

get_ready_vcluster_pod_count() {
    echo $((`kubectl get pods -A | grep vcluster-1-0 | grep $vclusterName | grep Running | grep 2/2 | wc -l`))
}

sleepSeconds=${1:-5}

while true
do
    sleep $((sleepSeconds))

    if [ $(get_ready_vcluster_pod_count) -ne 1 ]
    then
        echo "vcluster not ready"
    else
        echo "vcluster ready"
        break
    fi
done