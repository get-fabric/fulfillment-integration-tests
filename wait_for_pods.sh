#!/bin/sh

get_total_pods_count () {
    echo $((`kubectl --kubeconfig $kubeconigPath get pods --all-namespaces | grep -v "kube-system" | grep -E "$expectedStatus" | wc -l` - 1))
}

get_not_ready_pods_count () {get_not_ready_pods_count
    echo $((`kubectl --kubeconfig $kubeconigPath get pods --all-namespaces | grep -v "kube-system" | grep -E "$expectedStatus" | grep 0/ | wc -l`))
}

expectedStatus=${1}
sleepSeconds=${2:-5}
kubeconigPath=${3:-~/.kube/config}

total=0
ready=-1
until [ $total -eq $ready ]
do
    sleep $((sleepSeconds))

    total=$(get_total_pods_count)
    notReady=$(get_not_ready_running_pods_count)
    ready=$(( total - notReady ))

    echo $ready/$total pods ready
done
