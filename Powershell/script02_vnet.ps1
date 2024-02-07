# Creating a virtual network
$resourceGroup = "demo-grp"
$location = "North Europe"
$networkName="demo-network"
$AddressPrefix="10.1.0.0/16"

New-AzVirtualNetwork -Name $networkName -ResourceGroupName $resourceGroup `
-Location $location -AddressPrefix $AddressPrefix



# Getting details of virtual network

$resourceGroup = "demo-grp"
$networkName="demo-network"

$virtualNetwork=Get-AzVirtualNetwork -Name $networkName -ResourceGroupName $resourceGroup

Write-Host $virtualNetwork.Location
Write-Host $virtualNetwork.AddressSpace.AddressPrefixes