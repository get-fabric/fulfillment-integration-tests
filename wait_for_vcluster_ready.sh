#!/bin/sh

get_ready_vcluster_pod_count() {
    echo $((`kubectl --kubeconfig ./kubeconfig.yaml get pods --all-namespaces | grep -v "vcluster" | grep "Running" | grep 2/2 | wc -l`))
}

sleepSeconds=${1:-5}

while true
    sleep $((sleepSeconds))

    if [ $(get_ready_vcluster_pod_count) -ne 1 ]
    then
        echo "vcluster not ready"
    else
        echo "vcluster ready"
        break
    fi

done
