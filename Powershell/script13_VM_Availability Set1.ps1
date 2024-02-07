# Creating an Vm in Availability Set

$resourceGroup = "demo-grp"
$location = "North Europe"
$vmName="appvm"
$vmSize="Standard_DS2_v2"
$vmImage = "Win2019Datacenter"
$nsgName="demo-nsg"
$vmPublicIP="demo-public-ip"
$virtualNetworkName="demo-network"
$subnetName="SubnetA"
$availabilitySetName="demo-set"

# Get-AzVMSize -Location "North Europe"

New-AzVM -ResourceGroupName $resourceGroup -Location $location -Name $vmName -VirtualNetworkName $virtualNetworkName `
-SubnetName $subnetName -Size $vmSize -Image $vmImage -SecurityGroupName $nsgName -PublicIpAddressName $vmPublicIP `
-Credential (Get-Credential) -AvailabilitySetName $availabilitySetName

