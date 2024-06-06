# Install updates on a VM
Write-Output "Installing updates..."
Install-Module -Name PSWindowsUpdate -Force -SkipPublisherCheck
Import-Module PSWindowsUpdate
Install-WindowsUpdate -AcceptAll -AutoReboot