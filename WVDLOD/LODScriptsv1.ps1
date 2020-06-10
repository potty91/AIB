Install-Module -Name Az -AllowClobber -Scope CurrentUser


# Connect to Azure with a browser sign in token
Connect-AzAccount

$azsub = get-azsubscription
set-azcontext -subscriptionid $azsub.subscriptionid

Register-AzProviderFeature -FeatureName VirtualMachineTemplatePreview -ProviderNamespace Microsoft.VirtualMachineImages

Get-AzProviderFeature -FeatureName VirtualMachineTemplatePreview -ProviderNamespace Microsoft.VirtualMachineImages


Register-AzResourceProvider -ProviderNamespace Microsoft.VirtualMachineImages
Register-AzResourceProvider -ProviderNamespace Microsoft.Storage
Register-AzResourceProvider -ProviderNamespace Microsoft.Compute
Register-AzResourceProvider -ProviderNamespace Microsoft.KeyVault


Get-AzResourceProvider -ProviderNamespace Microsoft.VirtualMachineImages | Where RegistrationState -ne Registered
Get-AzResourceProvider -ProviderNamespace Microsoft.Storage | Where RegistrationState -ne Registered 
Get-AzResourceProvider -ProviderNamespace Microsoft.Compute | Where RegistrationState -ne Registered
Get-AzResourceProvider -ProviderNamespace Microsoft.KeyVault | Where RegistrationState -ne Registered



# get existing context
$currentAzContext = Get-AzContext
 
# destination image resource group
$imageResourceGroup="WVD-Images-RG"
 
# location
$location="EastUS"
 
# get your current subscription
$subscriptionID=$currentAzContext.Subscription.Id
 
# name of the image to be created
$imageName="WVD-Win10-Img"
 
# image distribution metadata reference name
$runOutputName="WVD-Win10-Meta"
 
# image template name
$imageTemplateName="WVD-Win10-Img-Template"
 
# distribution properties object name (runOutput), i.e. this gives you the properties of the managed image on completion
$runOutputName="winclientR01"
 
# WVD latest SKU
$SkuName="19h2-evd"
 
# create resource group
New-AzResourceGroup -Name $imageResourceGroup -Location $location

#################################################################################################################################################################################
# Start here if you have completed Exercise 1:
#################################################################################################################################################################################
#setup role def names, these need to be unique
$timeInt=$(get-date -UFormat "%s")
$imageRoleDefName="Image Builder Def WVD"+$timeInt
$idenityName="aibIdentity"+$timeInt


## Add AZ PS module to support AzUserAssignedIdentity
Install-Module -Name Az.ManagedServiceIdentity

# create identity
New-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name AIBuilderWVD

$idenityName="AIBuilderWVD"

$idenityNameResourceId=$(Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $idenityName).Id
$idenityNamePrincipalId=$(Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $idenityName).PrincipalId

# create temp folder 
$FolderPath = "C:\temp\"
New-Item -Path $FolderPath -ItemType Directory -Force

$aibRoleImageCreationUrl="https://raw.githubusercontent.com/PeterR-msft/M365WVDWS/master/Azure%20Image%20Builder/aibRoleImageCreation.json"
$aibRoleImageCreationPath = $FolderPath + "aibRoleImageCreation.json"

# download config
Invoke-WebRequest -Uri $aibRoleImageCreationUrl -OutFile $aibRoleImageCreationPath -UseBasicParsing

((Get-Content -path $aibRoleImageCreationPath -Raw) -replace '<subscriptionID>',$subscriptionID) | Set-Content -Path $aibRoleImageCreationPath
((Get-Content -path $aibRoleImageCreationPath -Raw) -replace '<rgName>', $imageResourceGroup) | Set-Content -Path $aibRoleImageCreationPath
((Get-Content -path $aibRoleImageCreationPath -Raw) -replace 'Azure Image Builder Service Image Creation Role', $imageRoleDefName) | Set-Content -Path $aibRoleImageCreationPath

# create role definition
New-AzRoleDefinition -InputFile $aibRoleImageCreationPath


#$imageRoleDefName ="aibIdentity1591690145.47891"


# grant role definition to image builder service principal
New-AzRoleAssignment -ObjectId $idenityNamePrincipalId -RoleDefinitionName $imageRoleDefName -Scope "/subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup"



#################################################################################################################################################################################

# Shared Image Gallery properties
$sigGalleryName= "WVDSIG"
$imageDefName ="WVD-Img-Definitions"
 
# create SIG
New-AzGallery -GalleryName $sigGalleryName -ResourceGroupName $imageResourceGroup -Location $location
 
# create gallery definition
New-AzGalleryImageDefinition -GalleryName $sigGalleryName -ResourceGroupName $imageResourceGroup -Location $location -Name $imageDefName -OsState generalized -OsType Windows -Publisher 'Contoso' -Offer 'Windows' -Sku 'Win10WVD'


# Shared Image Gallery properties
$sigGalleryName= "WVDSIG"
$imageDefName ="WVD-Img-Definitions"
 
# create SIG
New-AzGallery -GalleryName $sigGalleryName -ResourceGroupName $imageResourceGroup -Location $location
 
# create gallery definition
New-AzGalleryImageDefinition -GalleryName $sigGalleryName -ResourceGroupName $imageResourceGroup -Location $location -Name $imageDefName -OsState generalized -OsType Windows -Publisher 'Contoso' -Offer 'Windows' -Sku 'Win10WVD'


# assign permissions for the resource group, so that AIB can distribute the image to it
New-AzRoleAssignment -ApplicationId cf32a0cc-373c-47c9-9156-0db11f6a6dfc -Scope /subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup -RoleDefinitionName Contributor


# create temp folder 
$FolderPath = "C:\temp\"
New-Item -Path $FolderPath -ItemType Directory -Force
 
# download AIB template from GitHub
$templateName="armTemplateWinSIG.json"
$templateUrl="https://raw.githubusercontent.com/PeterR-msft/M365WVDWS/master/Azure%20Image%20Builder/armTemplateWinSIG.json"
$templateFilePath = $FolderPath + $templateName
Invoke-WebRequest -Uri $templateUrl -OutFile $templateFilePath -UseBasicParsing
 
# Run text replacement using variables set in exercise 1
((Get-Content -path $templateFilePath -Raw) -replace '<machinesku>',$machinesku) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<subscriptionID>',$subscriptionID) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<rgName>',$imageResourceGroup) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<imageDefName>',$imageDefName) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<runOutputName>',$runOutputName) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<skuName>',$SkuName) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<sharedImageGalName>',$sigGalleryName) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<region1>',$location) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<imgBuilderId>',$idenityNameResourceId) | Set-Content -Path $templateFilePath



New-AzResourceGroupDeployment -ResourceGroupName $imageResourceGroup -TemplateFile $templateFilePath -api-version "2019-05-01-preview" -imageTemplateName $imageTemplateName -svclocation $location


Invoke-AzResourceAction -ResourceName $imageTemplateName -ResourceGroupName $imageResourceGroup -ResourceType Microsoft.VirtualMachineImages/imageTemplates -ApiVersion "2019-05-01-preview" -Action Run -Force


(Get-AzResource -ResourceGroupName $imageResourceGroup -ResourceType Microsoft.VirtualMachineImages/imageTemplates -Name $ImageTemplateName).Properties.lastRunStatus