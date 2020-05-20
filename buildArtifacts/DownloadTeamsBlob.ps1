$Path = "C:\Install"
$Installer = "Teams_windows_x64.msi"
Invoke-WebRequest "https://vseinfraimages.blob.core.windows.net/images/Teams_windows_x64.msi?sv=2019-02-02&st=2020-05-20T13%3A27%3A04Z&se=2020-12-31T23%3A00%3A00Z&sr=b&sp=r&sig=oUZ%2Be%2FDgDaAc6i49W%2FI%2Ft%2F%2FsVJeCNWzELuoh4VYF%2Bec%3D" -OutFile $Path\$Installer
#Start-Process -FilePath $Path\$Installer -Args "/S" -Verb RunAs -Wait
#Remove-Item $Path\$Installer