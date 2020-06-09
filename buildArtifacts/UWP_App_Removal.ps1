# ---Script to remove built-in Windows Apps and deprovision them to avoid reinstallation from feature updates.
$apps='Microsoft.3DBuilder_15.2.10821.1000_neutral_~_8wekyb3d8bbwe',
'Microsoft.BingWeather_4.23.10923.0_neutral_~_8wekyb3d8bbwe',
#'Microsoft.DesktopAppInstaller_1.10.16004.0_neutral_~_8wekyb3d8bbwe', <- MSIX needs this!
'Microsoft.GetHelp_10.1706.1811.0_neutral_~_8wekyb3d8bbwe',
'Microsoft.Getstarted_5.12.2691.1000_neutral_~_8wekyb3d8bbwe',
'Microsoft.HEVCVideoExtension_1.0.2512.0_x64__8wekyb3d8bbwe',
'Microsoft.Messaging_2018.124.707.0_neutral_~_8wekyb3d8bbwe',
'Microsoft.Microsoft3DViewer_3.1803.29012.0_neutral_~_8wekyb3d8bbwe',
'Microsoft.MicrosoftOfficeHub_2017.715.118.0_neutral_~_8wekyb3d8bbwe',
'Microsoft.MicrosoftSolitaireCollection_3.18.12091.0_neutral_~_8wekyb3d8bbwe',
'Microsoft.MicrosoftStickyNotes_2.1.18.0_neutral_~_8wekyb3d8bbwe',
'Microsoft.MSPaint_4.1803.21027.0_neutral_~_8wekyb3d8bbwe',
#'Microsoft.Office.OneNote_2015.9126.21251.0_neutral_~_8wekyb3d8bbwe',
'Microsoft.OneConnect_3.1708.2224.0_neutral_~_8wekyb3d8bbwe',
'Microsoft.People_2017.1006.1846.1000_neutral_~_8wekyb3d8bbwe',
'Microsoft.Print3D_1.0.2422.0_neutral_~_8wekyb3d8bbwe',
'Microsoft.SkypeApp_12.1811.248.1000_neutral_~_kzf8qxf38zg5c',
#'Microsoft.StorePurchaseApp_11802.1802.23014.0_neutral_~_8wekyb3d8bbwe',
'Microsoft.Wallet_1.0.16328.0_neutral_~_8wekyb3d8bbwe',
#'Microsoft.Windows.Photos_2018.18022.15810.1000_neutral_~_8wekyb3d8bbwe',
#'Microsoft.WindowsAlarms_2017.920.157.1000_neutral_~_8wekyb3d8bbwe',
#'Microsoft.WindowsCalculator_2017.928.0.1000_neutral_~_8wekyb3d8bbwe',
'Microsoft.WindowsCamera_2017.1117.10.1000_neutral_~_8wekyb3d8bbwe',
'microsoft.windowscommunicationsapps_2015.9126.21425.0_neutral_~_8wekyb3d8bbwe',
'Microsoft.WindowsFeedbackHub_2018.323.50.1000_neutral_~_8wekyb3d8bbwe',
'Microsoft.WindowsMaps_2017.1003.1829.1000_neutral_~_8wekyb3d8bbwe',
'Microsoft.WindowsSoundRecorder_2017.928.5.1000_neutral_~_8wekyb3d8bbwe',
#'Microsoft.WindowsStore_11803.1001.613.0_neutral_~_8wekyb3d8bbwe',  <- Store is needed to download MSIX
'Microsoft.Xbox.TCUI_1.8.24001.0_neutral_~_8wekyb3d8bbwe',
'Microsoft.XboxApp_39.39.21002.0_neutral_~_8wekyb3d8bbwe',
'Microsoft.XboxGameOverlay_1.24.5001.0_neutral_~_8wekyb3d8bbwe',
'Microsoft.XboxIdentityProvider_2017.605.1240.0_neutral_~_8wekyb3d8bbwe',
'Microsoft.XboxSpeechToTextOverlay_1.21.13002.0_neutral_~_8wekyb3d8bbwe',
'Microsoft.ZuneMusic_2019.18011.13411.1000_neutral_~_8wekyb3d8bbwe',
'Microsoft.ZuneVideo_2019.17122.16211.1000_neutral_~_8wekyb3d8bbwe'
if(!(Test-Path HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned)){New-Item HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore  -Name Deprovisioned -Force} 
foreach($app in $apps){
$app = $app -replace "_.*"
Write-Output "Deleting $app"
Get-AppxPackage -Name "$app" | Remove-AppxPackage -AllUsers -Verbose
New-Item HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Deprovisioned -Name $app -Force
Write-Output "Deprovisioning $app"
}