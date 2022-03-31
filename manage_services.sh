#!/bin/sh

servicesFolder=$1
kubectlCommand=$2
kubeconigPath=${2:-~/.kube/config}
if [ -z "$2" ]; then
    echo "Usage: manage_services <folder> <'apply'|'delete'>"
    exit 1
fi

echo "Running \"kubectl $kubectlCommand\" on services in $servicesFolder"
echo "====================================================="

iterate_folder() {
  for item in */* ; do

    IFS='/'
    read -a tokens <<< "$item"
    namespace=${tokens[0]};
    service=${tokens[1]};

    if (! kubectl --kubeconfig $kubeconigPath get namespaces | grep -q $namespace)
    then
      #echo "Running - kubectl create namespace $namespace"
      kubectl --kubeconfig $kubeconigPath create namespace $namespace
    fi

    #echo "Running - kubectl $kubectlCommand -n $namespace -f ./$namespace/$service"
    kubectl --kubeconfig ./kubeconfig.yaml $kubectlCommand -n $namespace -f ./$namespace/$service

  done
}

(cd $servicesFolder && iterate_folder)
exit 0