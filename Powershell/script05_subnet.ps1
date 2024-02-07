# Adding a subnet for existing network

$resourceGroup ="demo-grp"
$networkName="demo-network"
$subnetName="SubnetA"
$subnetAddressPrefix="10.1.0.0/24"

#Reference of vnet
$virtualNetwork=Get-AzVirtualNetwork -Name $networkName-ResourceGroupName $resourceGroup

#Adding new subnet config to vnet
Add-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $virtualNetwork -AddressPrefix $subnetAddressPrefix

$virtualNetwork | Set-AzVirtualNetwork

