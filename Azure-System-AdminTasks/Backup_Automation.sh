#powershell script to back up a directory
$Source = "/var/lib/bin"
$Destination = "/temp/$(Get-Date -Format 2024-02-15:9:20:15 )"
Copy-Item -Path $source _Destination $destination -Recurse