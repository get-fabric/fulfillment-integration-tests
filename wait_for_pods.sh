#!/bin/sh

get_total_pods_count () {
    echo $((`kubectl --kubeconfig $kubeconigPath get pods -n $namespace | grep -E $expectedStatus | wc -l`))
}

get_not_ready_pods_count () {
    echo $((`kubectl --kubeconfig $kubeconigPath get pods -n $namespace | grep -E $expectedStatus  | grep 0/ | wc -l`))
}

namespace=${1}
expectedStatus=${2}
sleepSeconds=${3:-5}
kubeconigPath=${4:-~/.kube/config}

total=0
ready=-1
until [ $total -eq $ready ]
do
    sleep $((sleepSeconds))

    total=$(get_total_pods_count)
    notReady=$(get_not_ready_pods_count)
    ready=$(( total - notReady ))

    echo $ready/$total pods ready
done
