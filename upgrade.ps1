function Get-Upgrades {
    $upgrades = az aks get-upgrades --resource-group $resourceGroupName --name $clusterName --query "controlPlaneProfile.upgrades" 
    if ($upgrades) {
        $upgradePaths = ($upgrades | findstr kubernetesVersion).Replace("kubernetesVersion", "").Replace(":", "").Replace('"', '').Replace(" ", "")
        return $upgradePaths
    }
    return $null
}
$upgradePaths = Get-Upgrades
$lastUpgradeInPath = $upgradePaths[-1]
Write-Host $lastUpgradeInPath
while ($upgradePaths) {
    foreach ($upgradePath in $upgradePaths) {
        if ($upgradePath -eq $maxVersionNumber) {
            $upgradePaths = $null
            return
        }
        else {
            Write-Host "Upgrading to $upgradePath"
            az aks upgrade --resource-group $resourceGroupName --name $clusterName --kubernetes-version $upgradePath -y
        }
    }
}
Write-Host "Upgrade complete"