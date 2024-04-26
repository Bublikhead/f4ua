# Step 1: Prompt for directory path

$sourcePath = Read-Host "Enter the path inside 'data' folder (leave empty to use current directory)"
if ([string]::IsNullOrWhiteSpace($sourcePath)) {
    $sourcePath = Get-Location
}

Write-Output "Using source path: $sourcePath"

# Step 2: Find Fallout 4 folder
# Get all drives

$drives = Get-PSDrive -PSProvider 'FileSystem'

# Path to search for

$searchPath = "SteamLibrary\steamapps\common\Fallout 4\Data"

# Variable to track if the folder is found

$found = $false

# Loop through each drive and check for the path

foreach ($drive in $drives) {
    $fullPath = $drive.Root + $searchPath
    # Check if the path exists
    if (Test-Path $fullPath) {
        # Log the found path
        Write-Output "Fallout 4 data folder found at: $fullPath"
        $found = $true
    }
}

# Check if the folder was not found on any drive

if (-not $found) {
    Write-Output "Fallout 4 data folder not found"
}

# Step 3: Copy folders to Fallout 4 Data directory
# Full paths to the directories to be copied

$interfaceSource = Join-Path -Path $sourcePath -ChildPath "Interface"
$stringsSource = Join-Path -Path $sourcePath -ChildPath "strings"

# Ensure the destination path exists

if (-not (Test-Path -Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath
}

# Copy the "Interface" directory

if (Test-Path -Path $interfaceSource) {
    Copy-Item -Path $interfaceSource -Destination $destinationPath -Recurse -Force
} else {
    Write-Host "'Interface' folder not found at $interfaceSource"
}

# Copy the "Strings" directory
if (Test-Path -Path $stringsSource) {
    Copy-Item -Path $stringsSource -Destination $destinationPath -Recurse -Force
} else {
    Write-Host "'strings' folder not found at $stringsSource"
}

Write-Host "Installation completed."