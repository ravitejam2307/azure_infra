#Login-AzAccount #or
Connect-AzAccount  -Tenantid "40f38b8d-0fc6-4ac9-a011-ec9017122b83"
Set-AzContext -Subscription "5da0a9e4-e74f-4a1c-93dd-5af5b226153c"
#Logout-AzAccount

$resourceGroup ="demo-grp"
$networkName="demo-network"
$location ="North Europe"
$AddressPrefix  ="10.0.0.0/16"
$subnetName="SubnetA"
$subnetAddressPrefix="10.0.0.0/24"

#Creating Resource Group
New-AzVM -ResourceGroupName $resourceGroup -Location $location   

#Virtual network
$subnet = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix $subnetAddressPrefix 

New-AzVirtualNetwork -Name $networkName -ResourceGroupName $resourceGroup `
-Location $location -AddressPrefix $AddressPrefix -Subnet $subnet

#publicIPAddress
$publicIPAddress="demo-ip"

$publicIPAddress=New-AzPublicIpAddress -Name $publicIPAddress -ResourceGroupName $resourceGroup `
-Location $location -AllocationMethod Dynamic
 
#networkInterfaceName
$networkInterfaceName="demo-interface"
#Reference of vnet
$VirtualNetwork=Get-AzVirtualNetwork -Name $networkName -ResourceGroupName $resourceGroup
#Reference of our subnet
$subnet=Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $VirtualNetwork -Name $subnetName
#new AzNetwork Interface
$networkInterface=New-AzNetworkInterface -Name $networkInterfaceName -ResourceGroupName $resourceGroup -Location $location `
-SubnetId $subnet.Id -IpConfigurationName "IpConfig"


#Attach the public Ip address to the network Interface
$IpConfig= Get-AzNetworkInterfaceIpConfig -NetworkInterface $networkInterface
$networkInterface | Set-AzNetworkInterfaceIpConfig -PublicIpAddress $publicIPAddress `
-Name $IpConfig.Name

$networkInterface | Set-AzNetworkInterface


#Creating NSG Rules to VM
$networkSecurityGroupName="demo-nsg"
#new networksecurityrule1 config - RDP 
$nsgRule1=New-AzNetworkSecurityRuleConfig -Name Allow-RDP -Access Allow -Protocol Tcp -Direction Inbound -Priority 120 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix 10.1.0.0/24 -DestinationPortRange 3389
#new networksecurityrule2 config - HTTP
$nsgRule2=New-AzNetworkSecurityRuleConfig -Name Allow-HTTP -Access Allow -Protocol Tcp -Direction Inbound -Priority 130 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix 10.1.0.0/24 -DestinationPortRange 80
#create new az network security group
$networkSecurityGroup=New-AzNetworkSecurityGroup -Name $networkSecurityGroupName -ResourceGroupName $resourceGroup `
-Location $location -SecurityRules $nsgRule1,$nsgRule2


#Attach the NSG to the subnet
Set-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $VirtualNetwork `
-NetworkSecurityGroup $networkSecurityGroup -AddressPrefix $subnetAddressPrefix

$VirtualNetwork | Set-AzVirtualNetwork

# Creating an Availability Set
$availabilitySetName="demo-set"
$availabilitySet= New-AzAvailabilitySet -ResourceGroupName $resourceGroup -Location $location -Name $availabilitySetName -Sku Aligned `
-PlatformFaultDomainCount 2 -PlatformUpdateDomainCount 5


#VM Creation
$vmName="demovm"
$VMSize="Standard_DS2_v2"

#$Credential = Get-Credential

$vmConfig=New-AzVMConfig -Name $vmName -VMSize $VMSize New-AzAvailabilitySetId $availabilitySet.Id
Set-AzVMOperatingSystem -VM $vmConfig -ComputerName $vmName -Credential $Credential -Windows
Set-AzureRmVMSourceImage -VM $vmConfig -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2022-Datacenter" -Version "latest"
$networkInterface=Get-AzNetworkInterface -Name $networkInterfaceName -ResourceGroupName $resourceGroup
$vm=Add-AzNetworkInterface -VM $vmConfig -Id $networkInterface.Id
Set-AzVMBootDiagnostic -Disable -VM $vm

# Attaching a data disk to VM
$vm=Get-AzVM -ResourceGroupName $resourceGroup -Name $vmName
$vm | Add-AzVMDataDisk -Name $diskName -DiskSizeInGB 16 -CreateOption Empty -Lun 0
$vm | Update-AzVM



