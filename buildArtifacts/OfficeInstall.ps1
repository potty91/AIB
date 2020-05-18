$CmdPath = "C:\Install\setup.exe"
$cmdArgList = "/configure `"C:\Install\Configuration.xml`\"""

Start-Process -FilePath $cmdPath -ArgumentList $cmdArgList -PassThru