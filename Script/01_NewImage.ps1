# get existing context
$currentAzContext = Get-AzContext

# destination image resource group
$imageResourceGroup="VSE_WVD_Images2"

# location (see possible locations in main docs)
$location="eastus2"

# your subscription, this will get your current subscription
$subscriptionID=$currentAzContext.Subscription.Id

# name of the image to be created
$imageName="VSEWVDCustomImgWin10"

# image template name
#$imageTemplateName="helloImageTemplateWin02ps"

$imageTemplateName="VSEWVDImageTemplate"

# distribution properties object name (runOutput), i.e. this gives you the properties of the managed image on completion
$runOutputName="winclientR01"

$templateFilePath = "armTemplateWinWVD.json"


New-AzResourceGroupDeployment -ResourceGroupName $imageResourceGroup -TemplateFile $templateFilePath -api-version "2019-05-01-preview" -imageTemplateName $imageTemplateName -svclocation $location

Invoke-AzResourceAction -ResourceName $imageTemplateName -ResourceGroupName $imageResourceGroup -ResourceType Microsoft.VirtualMachineImages/imageTemplates -ApiVersion "2019-05-01-preview" -Action Run -Force
