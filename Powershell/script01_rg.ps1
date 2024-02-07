# Running PowerShell scripts in Azure Cloud Shell
# Defining a value for the resource group
#AZURE LOGIN
Login-AzAccount #or
Connect-AzAccount  -Tenantid "40f38b8d-0fc6-4ac9-a011-ec9017122b83"
Set-AzContext -Subscription "5da0a9e4-e74f-4a1c-93dd-5af5b226153c"
Logout-AzAccount


$resourceGroup = "demo-grp"
$location = "North Europe"

New-AzResourceGroup -Name $resourceGroup -Location $location
