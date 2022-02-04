$getUpgrades = az aks get-upgrades --resource-group $resourceGroupName --name $clusterName --output table
$getUpgrades
$upgradeSteps = @("1.22.2", "1.22.4")

foreach ($upgradeStep in $upgradeSteps) {
    az aks upgrade --resource-group $resourceGroupName --name $clusterName --kubernetes-version $upgradeStep -y
}


$getUpgrades