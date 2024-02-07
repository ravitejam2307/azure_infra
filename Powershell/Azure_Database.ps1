$PSVersionTable.PSVersion
Install-Module -Name Az

Get-InstalledModule -Name Az | select Name, Version

#Connect to Azure account
Connect-AzAccount -Tenant '2b9eb124-502e-4c37-b5d4-d50a2dbd472e'

$resourceGroupName = "MyAzureSQLRG"
$location = "centralindia"
$serverName = "demosqlserver"
$databaseName = "DemoDatabase"
$adminSqlLogin = "SqlAdmin"
$password = "admin@123"

#Create an Azure Resource Group
New-AzResourceGroup -Name $resourceGroupName  -Location $location

#Create an Azure SQL Server
$server = New-AzSqlServer -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -Location $location `
    -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminSqlLogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))

#To retrieve the fully qualified name.
Get-AzSqlServer | select FullyQualifiedDomainName

#Connect to Azure SQL database and creates a new database
$database = New-AzSqlDatabase  -ResourceGroupName $resourceGroupName `
-ServerName $serverName `
-DatabaseName $databaseName `
-RequestedServiceObjectiveName "S0" `  #Tempdb sizes-13.9 GB
-SampleName "AdventureWorksLT"

<#
#Configure the Server Firewall Rule
$startIp = "10.0.1.10"
$endIp = "10.0.1.15"
$serverFirewallRule = New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -FirewallRuleName "AllowedIPs" -StartIpAddress $startIp -EndIpAddress $endIp
    Address $endIp
    or
    $server | New-AzSqlServerFirewallRule -AllowAllAzureIPs
    Write-Host "Firewall rules configured."
#>

Get-AzSqlDatabase -ResourceGroupName  $resourceGroupName  -ServerName $serverName 
Write-Host "Azure SQL Database '$databaseName' created."
# Output connection string
Write-Host "Connection string:"
Write-Host "Server: $($server.ServerName)"
Write-Host "Database: $($database.DatabaseName)"
Write-Host "Username: $($adminLogin)"
Write-Host "Password: $($adminPassword)"

#Query the Azure SQL database for validations in Azure Portal

#Remove resources if not required
Remove-AzResourceGroup -Name $resourceGroupName

#################################################
<#
1.Creates a new resource group using New-AzResourceGroup.
2.Creates a new SQL Server using New-AzSqlServer.
3.Creates a new SQL Database using New-AzSqlDatabase.
4.Optionally, configures firewall rules to allow access to the database.
#>