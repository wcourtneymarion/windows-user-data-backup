# Prompt for whether to copy only student data
$copyOnlyStudents = Read-Host "Copy only student data? (Y/N)"

# Define the source and destination paths
$sourceFolders = @("Desktop", "Documents", "Downloads")
$destinationDrive = "D:\"

# Get the list of user profiles on the computer
$profiles = Get-ChildItem -Path "C:\Users" | Where-Object { $_.PSIsContainer }

# Loop through each user profile
foreach ($profile in $profiles) {
    $userName = $profile.Name
    $userPath = $profile.FullName

    # Check if user is a student based on the name
    $isStudent = $userName -match '^\d'

    # Copy the specified folders for the user
    foreach ($folder in $sourceFolders) {
        $sourceFolder = Join-Path -Path $userPath -ChildPath $folder
        $destinationFolder = Join-Path -Path $destinationDrive -ChildPath $userName

        # Create the user folder on the destination drive if it doesn't exist
        if (-not (Test-Path -Path $destinationFolder)) {
            New-Item -ItemType Directory -Path $destinationFolder | Out-Null
        }

        # Copy the folder contents (excluding subfolders)
        Get-ChildItem -Path $sourceFolder -File | Copy-Item -Destination $destinationFolder
    }

    # Skip non-student users if copying only student data
    if ($copyOnlyStudents -eq "Y" -and !$isStudent) {
        continue
    }
}
