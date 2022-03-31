#!/bin/sh

servicesFolder=$1
kubectlCommand=$2
kubeconigPath=${3:-~/.kube/config}
if [ -z "$2" ]; then
    echo "Usage: manage_services <folder> <'apply'|'delete'>"
    exit 1
fi

echo "Running \"kubectl $kubectlCommand\" on services in $servicesFolder"
echo "====================================================="

iterate_folder() {
  ls
  for item in */* ; do

    IFS='/'
    read -a tokens <<< "$item"
    namespace=${tokens[0]};
    service=${tokens[1]};

    if (! kubectl get namespaces | grep -q $namespace --kubeconfig $kubeconigPath)
    then
      #echo "Running - kubectl create namespace $namespace"
      kubectl create namespace $namespace --kubeconfig $kubeconigPath
    fi

    #echo "Running - kubectl $kubectlCommand -n $namespace -f ./$namespace/$service"
    kubectl $kubectlCommand -n $namespace -f ./$namespace/$service --kubeconfig $kubeconigPath

  done
}

(cd $servicesFolder && iterate_folder)
exit 0