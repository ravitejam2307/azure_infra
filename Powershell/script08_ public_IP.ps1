# Creating Public IP Address

$resourceGroup = "demo-grp"
$location = "North Europe"
$publicIPAddressName="demo-public-ip"

# Creating New public IP Address name,resourcegrp name,location
New-AzPublicIpAddress -Name $publicIPAddressName -ResourceGroupName $resourceGroup -Location $location -AllocationMethod Dynamic