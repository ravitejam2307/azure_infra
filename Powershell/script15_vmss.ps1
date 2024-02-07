# Creating the virtual machine scale set

$resourceGroup = "demo-grp"
$location = "North Europe"
$scaleSetName="demoapp-set"
$virtualNetworkName="new-network"
$subnetName="SubnetA"
$vmImage = "Win2019Datacenter"
$vmSize="Standard_DS2_v2"

#
New-AzVmss -ResourceGroupName $resourceGroup -Location $location -VMScaleSetName $scaleSetName `
  -VirtualNetworkName $virtualNetworkName -SubnetName $subnetName -PublicIpAddressName "myPublicIPAddress" `
  -ImageName $vmImage -UpgradePolicyMode "Automatic" -VmSize $vmSize -Credential (Get-Credential)