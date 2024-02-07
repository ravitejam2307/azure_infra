# Creating an Azure virtual machine

$resourceGroup = "demo-grp"
$location = "North Europe"
$vmName="demovm"
$vmSize="Standard_D2S_v2"
$vmImage = "Win2019Datacenter"
$nsgName="demo-nsg"
$vmPublicIP="demo-public-ip"
$virtualNetworkName="demo-network"
$subnetName="SubnetA"

# Get-AzVMSize -Location "North Europe"

New-AzResourceGroup -Name $resourceGroup -Location $location

New-AzVM -ResourceGroupName $resourceGroup `
         -Location $location 
         -Name $vmName 
         -VirtualNetworkName $virtualNetworkName `
         -SubnetName $subnetName 
         -Size $vmSize 
         -Image $vmImage 
         -SecurityGroupName $nsgName 
         -PublicIpAddressName $vmPublicIP `
         -Credential (Get-Credential)

  
<#
## Another method for creating VM
$vmName="demovm"   
$vmSize="Standard_DS2_v2"      
$location = "North Europe"

$Credential = Get-Credential

$vmConfig = New-AzVMConfig -VMName $vmName -VMSize $VMSize
Set-AzVMOperatingSystem -VM $vmConfig -ComputerName $vmName -Credential $Credential -Windows

Set-AzureRmVMSourceImage -VM $vmConfig -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2022-Datacenter" -Version "latest"

$networkInterfaceName="demo-interface"
$networkInterface= Get-AzNetworkInterface -Name $networkInterfaceName -ResourceGroupName $resourceGroup

$vm=Add-AzNetworkInterface -VM $vmConfig -Id $networkInterface.Id

Set-AzVMBootDiagnostic -Disable -VM $vm

New-AzVM -ResourceGroupName $resourceGroup -Location $location -VM $vm  
#>
