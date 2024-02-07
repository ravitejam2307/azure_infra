#get-host 
#get-command
#get-command *service* or 
(get-command *service*).count
get-command *-service*
#get-help get-help
get-help get-service
get-help get-service -examples
get-help get-process
get-help get-process -Detailed
get-help Test-Connection
get-command -Module Microsoft.Powershell.Management
get-command -Module Az.Compute
#get-command -ParameterName ComputerName
get-command *service* -ParameterName ComputerName
get-service
get-service -name wmi*
get-service -DisplayName "network*"
"WinRM" | Get-Service

#Get Services on multiple computers

Get-Service -Name "WinRM" -ComputerName "localhost", "Server01", "Server02" | Format-Table -Property MachineName, Status, Name, DisplayNAme -AutoSize
#############3
Get-service -Name Dhcp
$name = Get-Service -Name Dhcp | select -ExpandProperty name 

if($name -eq 'Dhcp'){
write-host "you are looking at dhcp service"
}
else{
write-host "you are looking at something else"
} 


#get-psdrive
#get-process