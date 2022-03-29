#!/bin/sh

mkdir -p logs
namespace=$1
since=$2

pods=$(kubectl get pods -n $namespace --no-headers -o custom-columns=":metadata.name")
for pod in $pods ; do
    kubectl -n $namespace logs --since=$since $pod > logs/$pod.log
done
