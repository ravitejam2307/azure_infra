# Creating a network interface

$resourceGroup = "demo-grp"
$networkName="demo-network"
$subnetName="SubnetA"
$networkInterfaceName = "demo-interface"

#Reference of vnet
$virtualNetwork=Get-AzVirtualNetwork -Name $networkName -ResourceGroupName $resourceGroup

#Reference of our subnet
$subnet=Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $virtualNetwork -Name $subnetName

#new AzNetwork Interface
New-AzNetworkInterface -Name $networkInterfaceName -ResourceGroupName $resourceGroup -Location $location -SubnetId $subnet.Id -IpConfigurationName "demoIpConfig"