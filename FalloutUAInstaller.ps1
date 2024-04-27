# Get translation folder path
$sourcePath = Read-Host "Вкажіть папку до файлів перекладу (всередині /data) або залиште порожнім, якщо хочете використати поточну директорію"
if ([string]::IsNullOrWhiteSpace($sourcePath)) {
    $sourcePath = Get-Location
}

Write-Output "Папка перекладів: $sourcePath"

# Get all drives on the system
$drives = Get-PSDrive -PSProvider FileSystem

# Variable to keep track of found paths
$destinationPaths = @()

# Loop through each drive
foreach ($drive in $drives) {
    # Use Get-ChildItem to recursively search for 'Fallout 4' folders
    $falloutFolders = Get-ChildItem -Path $drive.Root -Directory -Recurse -ErrorAction SilentlyContinue -Filter "Fallout 4"
    
    foreach ($folder in $falloutFolders) {
        $dataPath = Join-Path -Path $folder.FullName -ChildPath "Data"
        # Check if the Data folder exists within the Fallout 4 folder
        if (Test-Path $dataPath) {
            # Add the path to the list of found paths
            $destinationPaths += $dataPath
        }
    }
}

# Output all found paths
if ($destinationPaths.Count -gt 0) {
    Write-Output "Fallout 4/data знайдено за наступним шляхом:"
    $destinationPaths | ForEach-Object { Write-Output $_ }
} else {
    Write-Output "Папки Fallout 4/data не знайдено. Переконайтесь, що папка існує."
}

# Ensure that the source path exists
if (Test-Path -Path $sourcePath) {
    # Get directories (child folders) in the source path
    $directories = Get-ChildItem -Path $sourcePath -Directory
    # Ensure destination path is not null or empty
    if (-not [String]::IsNullOrWhiteSpace($destinationPaths)) {
        # Loop through each directory and copy it to the destination
        foreach ($dir in $directories) {
            $destPath = Join-Path -Path $destinationPaths -ChildPath $dir.Name
            Copy-Item -Path $dir.FullName -Destination $destPath -Recurse -Force
        }
        Write-Host "Файли перекладів скопійовані з $sourcePath до $destinationPaths."
    } else {
        Write-Host "Шлях до гри не існує. Переконайтесь, що папка існує."
        Write-Host "Інсталіція не успішна."
        exit
    }
} else {
    Write-Host "Папка $sourcePath не існує."
    Exit
}

# Loop through each drive
foreach ($drive in $drives) {

    # Get Fallout4 folder
    $falloutDirs = Get-ChildItem -Path $drive.Root -Directory -Recurse -ErrorAction SilentlyContinue -Filter "Fallout4"   
     
    foreach ($dir in $falloutDirs) {
        $iniPath = Join-Path -Path $dir.FullName -ChildPath "Fallout4.ini"
        # Check if the Fallout4.ini file exists within the Fallout4 folder
        if (Test-Path $iniPath) {
            # Read the contents of the ini file
            $iniContent = Get-Content $iniPath         
            # Check if the bInvalidateOlderFiles is set to 1
            if ($iniContent -match 'bInvalidateOlderFiles=1') {
                Write-Host "Конфігурацію Fallout4.ini вже оновленно."
            } else {
                # Modify the ini file content
                $newContent = $iniContent -replace 'bInvalidateOlderFiles=0', 'bInvalidateOlderFiles=1'
                # Save the modified content back to the ini file
                Set-Content -Path $iniPath -Value $newContent
                Write-Host "Властивість bInvalidateOlderFiles оновленно в Fallout4.ini."
            }
        }
    }
}

Write-Host "Інсталяція успішна. Слава Україні!"