# Creating a storage account

$resourceGroup = "demo-grp"
$location = "NorthEurope"
$storageAccountName="demostor466566"
$accountSKU     ="Standard_LRS"
$storageAccountKind="StorageV2"

New-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName -Location $location `
-SkuName $accountSKU -Kind $storageAccountKind