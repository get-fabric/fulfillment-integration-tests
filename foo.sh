#!/bin/sh

servicesFolder=$1
kubectlCommand=$2
kubeconigPath=${3:-~/.kube/config}

kubectl --kubeconfig $kubeconigPath get namespaces
