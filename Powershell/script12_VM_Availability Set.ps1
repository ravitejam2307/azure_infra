# Creating an Availability Set

$resourceGroup = "demo-grp"
$location ="NorthEurope"
$availabilitySetName="demo-set"

New-AzAvailabilitySet -ResourceGroupName $resourceGroup -Location $location -Name $availabilitySetName -Sku Aligned `
-PlatformFaultDomainCount 2 -PlatformUpdateDomainCount 5