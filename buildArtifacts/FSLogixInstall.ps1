$CmdPath = "C:\Install\FSLogixAppsSetup.exe"
$cmdArgList = "/install /passive /norestart /log`"C:\Logs\FSLogix\FSlogix.txt`\"""
#$cmdArgList = "/install"

Start-Process -FilePath $cmdPath -ArgumentList $cmdArgList -PassThru | Wait-Process -Timeout 600