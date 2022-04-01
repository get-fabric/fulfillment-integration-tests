deployment_folder=$1
kubeconigPath=${2:-~/.kube/config}

for f in "$deployment_folder/fulfillment"/*; do basename $f .yaml >> services_folder; done
echo "====================================================="
echo "services in $deployment_folder:"
cat services_folder
echo "====================================================="

kubectl --kubeconfig $kubeconigPath get deployment -A --field-selector=metadata.namespace=fulfillment, --no-headers -o custom-columns=":metadata.name" | grep -v kafka > services_cluster
echo "====================================================="
echo "services in cluster:"
cat services_cluster
echo "====================================================="

node ./prepare/diff.js $deployment_folder

cat ./services_cluster_missing_from_folder | while read line || [ -n "$line" ]
do
   kubectl --kubeconfig $kubeconigPath delete deployment $line --namespace fulfillment || true
   kubectl --kubeconfig $kubeconigPath delete deployment $line-kafka-consumer --namespace fulfillment || true
   kubectl --kubeconfig $kubeconigPath delete deployment $line-kafka-producer --namespace fulfillment || true
done

rm -rf services_cluster_missing_from_folder
rm -rf services_folder
rm -rf services_cluster
