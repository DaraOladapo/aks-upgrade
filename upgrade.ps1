function Get-Upgrades {
    $upgrades = az aks get-upgrades --resource-group $resourceGroupName --name $clusterName --query "controlPlaneProfile.upgrades" 
    if ($upgrades) {
        $upgradePaths = ($upgrades | findstr kubernetesVersion).Replace("kubernetesVersion", "").Replace(":", "").Replace('"', '').Replace(" ", "")
        return $upgradePaths
    }
    return $null
}
Write-Host "$(Get-Date): Starting upgrade"
$upgradePaths = Get-Upgrades
Write-Host "Upgrading on path $upgradePaths"
while ($upgradePaths) {
    foreach ($upgradePath in $upgradePaths) {
        if ($upgradePath -eq $maxVersionNumber) {
            $upgradePaths = $null
            return
        }
        else {
            
            Write-Host "Upgrading to $upgradePath"
            az aks upgrade --resource-group $resourceGroupName --name $clusterName --kubernetes-version $upgradePath -y
            $upgradePaths = Get-Upgrades
        }
    }
}
Write-Host "$(Get-Date): Upgrade complete"