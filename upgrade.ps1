$getUprades = az aks get-upgrades --resource-group $resourceGroupName --name $clusterName --output table
$getUprades
$upgradeSteps=@("1.20.13", "1.21.2","1.21.7")

foreach ($upgradeStep in $upgradeSteps) {
    az aks upgrade --resource-group $resourceGroupName --name $clusterName --kubernetes-version $upgradeStep
}


$getUprades