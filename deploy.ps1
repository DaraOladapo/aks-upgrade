az provider show -n Microsoft.OperationsManagement -o table
az provider show -n Microsoft.OperationalInsights -o table


az group create --name $resourceGroupName --location $location

az aks create --resource-group $resourceGroupName --name $clusterName --kubernetes-version $oldVersionNumber --node-count 1 --enable-addons monitoring --generate-ssh-keys

az aks install-cli

az aks get-credentials --resource-group $resourceGroupName --name $clusterName

kubectl get nodes

kubectl apply -f azure-vote.yaml

kubectl get pods

kubectl scale --replicas=5 deployment/azure-vote-front

az aks show --resource-group $resourceGroupName --name $clusterName --query kubernetesVersion --output table

kubectl autoscale deployment azure-vote-front --cpu-percent=50 --min=3 --max=10

kubectl apply -f azure-vote-hpa.yaml

kubectl get service azure-vote-front --watch