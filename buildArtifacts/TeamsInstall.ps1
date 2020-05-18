$CmdPath = "C:\Install\Teams_windows_x64.msi"
$cmdArgList = "/l*v C:\Logs\Teams.log ALLUSER=1 ALLUSERS=1"

Start-Process -FilePath $cmdPath -ArgumentList $cmdArgList -PassThru | Wait-Process -Timeout 600