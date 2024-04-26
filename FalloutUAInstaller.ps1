$sourcePath = Read-Host "Enter the path inside 'data' folder (leave empty to use current directory)"
if ([string]::IsNullOrWhiteSpace($sourcePath)) {
    $sourcePath = Get-Location
}

Write-Output "Using source path: $sourcePath"

$drives = Get-PSDrive -PSProvider 'FileSystem'

$searchPath = "SteamLibrary\steamapps\common\Fallout 4\Data"

$found = $false

foreach ($drive in $drives) {
    $fullPath = $drive.Root + $searchPath
    # Check if the path exists
    if (Test-Path $fullPath) {
        # Log the found path
        Write-Output "Fallout 4 data folder found at: $fullPath"
        $found = $true
    }
}

if (-not $found) {
    Write-Output "Fallout 4 data folder not found"
}

$interfaceSource = Join-Path -Path $sourcePath -ChildPath "Interface"
$stringsSource = Join-Path -Path $sourcePath -ChildPath "strings"

if (-not (Test-Path -Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath
}


if (Test-Path -Path $interfaceSource) {
    Copy-Item -Path $interfaceSource -Destination $destinationPath -Recurse -Force
} else {
    Write-Host "'Interface' folder not found at $interfaceSource"
}

if (Test-Path -Path $stringsSource) {
    Copy-Item -Path $stringsSource -Destination $destinationPath -Recurse -Force
} else {
    Write-Host "'strings' folder not found at $stringsSource"
}

Write-Host "Installation completed."