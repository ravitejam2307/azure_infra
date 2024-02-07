 # Creating a Network Security Group

$resourceGroup = "demo-grp"
$location = "North Europe"
$networkSecurityGroupName = "demo-nsg"

#new networksecurityrule1 config - RDP 
$nsgrule1=New-AzNetworkSecurityRuleConfig -Name Allow-RDP -Access Allow -Protocol Tcp -Direction Inbound -Priority 120 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix 10.1.0.0/24 -DestinationPortRange 3389

#new networksecurityrule2 config - HTTP
$nsgrule2=New-AzNetworkSecurityRuleConfig -Name Allow-HTTP -Access Allow -Protocol Tcp -Direction Inbound -Priority 130 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix 10.1.0.0/24 -DestinationPortRange 80

#create new az network security group
New-AzNetworkSecurityGroup -Name $networkSecurityGroupName -ResourceGroupName $resourceGroup `
-Location $location -SecurityRules $nsgrule1,$nsgrule2