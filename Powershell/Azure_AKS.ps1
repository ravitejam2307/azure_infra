#Connect to Azure with a browser sign in token
Connect-AzAccount

$ResourceGroupName = "DemoAKS-RG"
$ClusterName = "DemoAKSCluster"
$ClusterLocation = "eastus"
$NodeCount = "3"
$NodeVMSize = "Standard_DS2_v2"

#Create a New resource group
New-AzResourceGroup -Name $ResourceGroupName -Location $ClusterLocation

#Creating the AKS cluster, GenerateSshKey is used here to authenticate to the cluster from the local machine.
New-AzAksCluster -ResourceGroupName $ResourceGroupName -Name $ClusterName -NodeCount $NodeCount -NodeVmSize $NodeVMSize -EnableRBAC $true -GenerateSshKey -KubernetesVersion 1.19.7
#or
#Already
New-AzAksCluster -ResourceGroupName $ResourceGroupName -Name $ClusterName -NodeCount $NodeCount -SshKeyValue #filepathxx

#Accessing the Kubernetes Cluster
Install-AzAksKubectl

#Now we need to add our AKS context so we can connect 
Import-AzAksCredential -ResourceGroupName $ResourceGroupName -Name $ClusterName -Force
Kubectl get nodes
kubectl config get-contexts

#or
# Get AKS credentials
Get-AzAksCredential -ResourceGroupName $ResourceGroupName -Name $ClusterName -Admin

# To interact with the AKS cluster using kubectl, you may need to set the current context
# kubectl config use-context <your-aks-cluster-name>

#To Delete your cluster run the following command
Remove-AzResourceGroup -Name $ResourceGroupName -force

#To delete that SSH Public Key we created above
Remove-Item C:\Users\ravi\.ssh\id_rsa


##########################################################
<#
1.Connects to Azure using Connect-AzAccount.
2.Creates a new resource group using New-AzResourceGroup.
3.Creates a new AKS cluster using New-AzAks.
4.Retrieves AKS cluster credentials using Get-AzAksCredential.
#>