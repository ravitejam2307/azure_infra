# A new virtual network with a subnet

$resourceGroup ="demo-grp"
$location ="North Europe"
$networkName="demo-network"
$AddressPrefix="10.1.0.0/16"
$subnetName="SubnetA"
$subnetAddressPrefix="10.1.0.0/24"

#new vnet with subnet its self
$subnet=New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix $subnetAddressPrefix

#new Az Virtual network in the subnet
New-AzVirtualNetwork -Name $networkName -ResourceGroupName $resourceGroup -Location $location -AddressPrefix $AddressPrefix -Subnet $subnet