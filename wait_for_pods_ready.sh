#!/bin/sh

get_total_running_pods_count () {
    echo $((`kubectl get pods --all-namespaces | grep -v "kube-system" | grep "Running" | wc -l` - 1))
}

get_not_ready_running_pods_count () {
    echo $((`kubectl get pods --all-namespaces | grep -v "kube-system" | grep "Running" | grep 0/ | wc -l`))
}

list_not_ready_runninng_pods () {
    kubectl get pods --all-namespaces | grep -v "kube-system" | grep "Running" | grep 0/1
}

sleepSeconds=${1:-5}

total=0
ready=-1
until [ $total -eq $ready ]
do
    sleep $((sleepSeconds))

    total=$(get_total_running_pods_count)
    notReady=$(get_not_ready_running_pods_count)
    ready=$(( total - notReady ))

    echo $ready/$total pods ready
    if [ $total -ne $ready ]
    then
        list_not_ready_runninng_pods
    fi
done
