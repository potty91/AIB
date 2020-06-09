
# Setup directory
New-Item C:\Source -type Directory

# Copy over build artifacts
Copy-Item "C:\buildArtifacts\buildArtifacts\*" -Destination "C:\Source" -Recurse

Invoke-WebRequest -Uri "https://statics.teams.cdn.office.net/production-windows-x64/1.3.00.4461/Teams_windows_x64.msi" -OutFile "C:\Source\Teams_windows_x64.msi"