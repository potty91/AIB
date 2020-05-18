$CmdPath = "C:\Install\MicrosoftEdgeEnterpriseX64.msi"
$cmdArgList = "/l*v C:\Logs\Edge.log ALLUSERS=1"

Start-Process -FilePath $cmdPath -ArgumentList $cmdArgList -PassThru