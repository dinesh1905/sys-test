# creates argumentfile for robotframework. (will be used as argument input for robot runs)
# script interface (parameters)
 param (
    [Parameter(Mandatory=$true)][string]$WorkspaceFolder,
    [Parameter(Mandatory=$true)][string]$FileBaseName
 )

# e.g. 20230727_123456
$DateTimeNow = Get-Date -Format "yyyyMMdd_HHmmss"

# contents of arguments.txt
$contentToAdd = @"
-b ${WorkspaceFolder}\results\${FileBaseName}_${DateTimeNow}\log.txt
-d ${WorkspaceFolder}\results\${FileBaseName}_${DateTimeNow}
"@

Set-Content -Path "${WorkspaceFolder}\.vscode\arguments.tmp" -Value $contentToAdd
