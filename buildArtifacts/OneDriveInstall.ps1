$CmdPath = "C:\Install\OneDriveSetup.exe"
$cmdArgList = "/allusers"

Start-Process -FilePath $cmdPath -ArgumentList $cmdArgList -PassThru | Wait-Process -Timeout 300 