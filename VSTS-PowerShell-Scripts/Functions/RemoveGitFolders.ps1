param(
    [Parameter(Mandatory)][array]
    $repoNames,
    [Parameter(Mandatory)][string]
    $location,
    $gitFolderName = ".git",
    $baseDir = "." 
)

Push-Location $location

#Remove Folders
#for each folder go through and remove the .git folder 
ForEach ($repoName in $repoNames) {

        # Go into the folder
        Push-Location $repoName
        
        #Get the .git folder to be removed
        $gitFolders = Get-ChildItem -Path $baseDir -Force | Where-Object { $_.Mode -match "h" -and $_.FullName -like "*\$gitFolderName" } | Remove-Item -Recurse -Force
        Write-Host "Removed .git folder"

        #pop out of the folder
        Pop-Location
}

Pop-Location