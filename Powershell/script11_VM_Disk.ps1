# Attaching a data disk to VM

$vmName ="demovm"
$resourceGroup="demo-grp"
$diskName     ="demo-disk"

$vm=Get-AzVM -ResourceGroupName $resourceGroup -Name $vmName

$vm | Add-AzVMDataDisk -Name $diskName -DiskSizeInGB 16 -CreateOption Empty -Lun 0

$vm | Update-AzVM


#Another Method
$resourceGroup = "demo-grp"
$location = "NorthEurope"
$vmName="demovm"
$dataDiskName="demo-disk"


# First we need to create a new disk configuration
$dataDiskConfig = New-AzDiskConfig -Location $location -CreateOption Empty -DiskSizeGB 16 -SkuName "Standard_LRS"
# Next we create the data disk
$dataDisk= New-AzDisk -ResourceGroupName $resourceGroup -DiskName $dataDiskName -Disk $dataDiskConfig
# We need to get a reference to the VM to attach the disk to
$vm=Get-AzVM -ResourceGroupName $resourceGroup -Name $vmName
# Then we attach the disk to the VM
$vm=Add-AzVMDataDisk -VM $vm -Name $dataDiskName -CreateOption Attach -ManagedDiskId $dataDisk.Id -Lun 0
# Then we need to update the VM
Update-AzVM -ResourceGroupName $resourceGroup -VM $vm 