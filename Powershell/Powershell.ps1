$names = @("ravi", "teja", "gupta")

for($i=0; $i -lt $names.Count;$i++){ #gt,lt
     
    if($names[$i] -eq "ravi"){   #ne-notequal
     
      Write-Host  "My name is $($names[$i])"
     }
     }


#Arrays

$names = @("ravi", "teja", "gupta")
$location = @("guntur", "hyderabad", "vizag
")

for($i=0;$i -lt $names.count;$i++){

Write-Host "My name is $($names[$i]) and I belongs to $($location[$i])"
}

#hash table

$hash = @{

ravi = "hyd"
teja = "guntur"

}

#even odd program

$number = Read-Host "Enter any number"
Write-Host "Entered number is $number"

if(($number%2) -eq 0){
    
    Write-Host "Number is Even"  -Foregroundcolor yellow
}
else{
    Write-Host "Number is Odd"   -ForegroundColor red
}     


#Identify all the even/odd between 1 and 100

$numbers = 1..100

foreach($number in $numbers){

    Write-Host "Number now is $number"

if(($number%2) -eq 0){
    
    Write-Host "Number is Even"  -Foregroundcolor yellow
    $number|out-file  -FilePath ".\even.txt" -Append
}
else{
    Write-Host "Number is Odd"   -ForegroundColor red
    $number|out-file  -FilePath ".\odd.txt"  -Append
}     
}


#AZURE LOGIN
Login-AzAccount #or
Connect-AzAccount  -Tenantid "XXXXXX"
Set-AzContext -Subscription "ZXXXXXXXX-id"
Logout-AzAccount


#Creating multiple resource groups

$num=Read-Host "How many resource groups do you want"
for($rg=1; $rg -le $num; $rg++){
$rsg=Read-Host "Enter the Rsg Name"
$loc=Read-Host "Enter the Rsg Location"

New-AzResourceGroup -Name "$rsg" -Location "$loc"
}

#Creating 100 RG's

$rgnames = @()

for($i=1;i -le 100;$i++){

$name = "testrg"
$rgnames+= $name + $i
}


##Array of rgs

$RgNames = @("testrg01", "testrg02", "testrg03")

foreach($name in $RgNames){

$checkrg = Get-AzResourceGroup -Name $name -Location "East US2"  -ErrorAction SilentlyContinue

if($checkrg -ne $null){
Write-Host "Rg with the name $name already exists. Skipping creation"
}
else{
Write-Host "Rg with the name $name doesn't exists. Attempting to create one!"
New-AzResourceGroup -Name $name -Location "East US2"
}
}

#Deleting the Resource groups Remove-AzResourceGroup

$rgNames = Get-AzResourceGroup|Where-Object{$_.ResourceGroupName -like "testrg*"}

foreach($value in $rgNames){

Write-Host "Deleting the rg with the name $($value.ResourceGroupName)" -ForegroundColor Cyan
Remove-AzResourceGroup -Name $value.ResourceGroupName -Force

}


##Creating New Resource group & New Storage Account

$rgName  = "testrg-stor"
$storageaccountname = "devstorabc000"
$location = "East US2"

#Create a new RG

New-AzResourceGroup -Name $rgName -Location $location

Write-Host "Creating the storage account"

#RgName -- parameter
#Name -- Storage (parameter)
#Location  -- parameter
#Redundancy - sku 
#Kind - standard/Permium
#Access tier - Hot/cool

New-AzStorageAccount -ResourceGroupName $rgName
                     -Name $storageaccountname 
                     -SkuName Standard_LRS
                     -Location $location
                     -Kind StorageV2 
                     -AccessTier Hot 
                      
#Changing exsiting storage account

Set-AzStorageAccount -ResourceGroupName $rgName
                     -Name $storageaccountname 
                     -SkuName Standard_GRS
                     -Location $location
                     -Kind StorageV2 
                     -AccessTier Hot  

#Create multiple storage --check if/else
#Creating a container
##Upload a blob

# 1 rg
# 1 storage account
# 1 container
# 1 upload of a blob

## parameters

$rgName = "testrgps"
$location = "East US2"
$storageaccountname = "devstorpsabc000"
$filepath  = "D:\psfolder\img1.jpg" # For Single file
$filepath  = "D:\psfolder\*.jpg"    # For multiple files

## create the rg

New-AzResourceGroup -Name $rgName -Location $location

## creating the storage

New-AzStorageAccount -ResourceGroupName $rgName 
                     -Name $storageaccountname
                     -SkuName Standard_LRS
                     -Location $location
                     -Kind   storageV2
                     -AccessTier Hot

##Storage Context
$context = Get-AzStorageAccount -ResourceGroupName $rgName -Name $storageaccountname

## creating container in storage account

New-AzStorageContainer -Name "testcontainer" 
                       -permission off or Blob or Container or Unknown
                       -Context $context.Context 

## Uploading a blob in container

Set-AzStorageBlobContent -File $filepath -Container "testcontainer" -Blob "sampleblob" -Context $context.Context


## Upload Multiple files to container

## get all the images

$images = Get-Childitem -path $filepath
$names = $images.Name|Where-Object{$_ -like "img**"}

foreach($name in $names){

set-AzStorageBlobContent  -File $name -Container "testcontainer" -Context $context.Context
}







## Complete storage account with container and upload file 

$rgname="testrgps"
$storagename = "devstorpsabc001"
$containers = @("container1", "container2", "container3")
$filepath  = "D:\psfolder" # For folder location of files

## Script

$rgcheck = Get-AzresourceGroup -Name $rgName -ErrorAction SilentlyContinue

if($rgcheck -ne $null){

Write-Host "Rg with the name already exists. skipping creation"
}
else{
Write-Host "Rg with the name $rgName doesn't exist. Creating one now!!"
New-AzResourceGroup -Name $rgName -Location "East US2"

}

#Storage check 

$storcheck  = Get-AzStorageAccount -ResourceGroupName $rgName -NAme $storagename -ErrorAction SilentlyContinue

if($storcheck -ne $null){

Write-Host "storage account with the name $storagename already exists. Skipping creation"

}

else{

Write-Host "storage account with the name $storagename doesn't exists. Creating now!"

New-AzStorageAccount -ResourceGroupName $rgname
                     -Name $storagename
                     -SkuName Standard_LRS
                     -Location "East US2"
                     -Kind Storagev2
                     -AccessTier Hot


$context = (get-AzStorageAccount -ResourceGroupName $rgName -Name $storagename).Context

#creating containers

Foreach($container in $containers){
Write-Host "Working on the container with the name $container"
New-AzStorageContainer -Name $container -Permission Off -Context $context

$names = Get-Childitem -Path $filepath|Where-object{$_.Name -like "img**"}

foreach($name in $names){

Set-AzStorageBlobContent -File $name -Container $container -Context $context


}

}


##Parameter in powershell

param(
$name = "Ravi"
)
Write-Host "My name is $name"

##Calling parameter file in powershell

.\sample.ps1 -name "teja"

##File creation in powershell 

New-Item -Path ".\config.txt" -ItemType File

Add-Content -Path .\config.txt -Value "This is a new line of text."

Get-Content -Path .\config.txt

##Convert json file to powershell standing format

$data = Get-Content -Path .\config.json|ConvertFrom-Json

Write-Host "Name of the storage account is" $data.storageaccountname
Write-Host "Location of the storage account is" $data.location
Write-Host "Sku of the storage is" $data.skuname
Write-Host "The name of the rg is" $data.rgname

Write-Host "Starting the Rg creation"
New-AzResourceGroup -Name $data.rgname -Location $data.location

Write-Host "Starting the storage creation"
New-AzStorageAccount -ResourceGroupName $data.rgname -name  $data.storageaccountname