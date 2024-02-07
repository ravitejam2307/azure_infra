# Getting virtual network details while creating the network

$resourceGroup = "demo-grp"
$location = "North Europe"
$networkName= "demo-network"
$AddressPrefix= "10.1.0.0/16"

#Removing the existing vnet 
Remove-AzVirtualNetwork -Name $networkName -ResourceGroupName $resourceGroup

#recreating the vnet
$virtualnetwork = New-AzVirtualNetwork -Name $networkName -ResourceGroupName $resourceGroup -Location $location -AddressPrefix $AddressPrefix
Write-Output $virtualnetwork.Location
Write-Output $virtualnetwork.AddressSpace.AddressPrefixes
Write-Output $virtualnetwork.Id