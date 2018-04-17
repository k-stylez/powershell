param(
    [Parameter(Mandatory)][string]
    $gitcred,
    [Parameter(Mandatory)][array]
    $gitFolders,
    [Parameter(Mandatory)][string]
    $location,
    # The command you want to perform
    $cmd = "status"
)

Push-Location $location

ForEach ($gitFolder in $gitFolders) {

        # Remove the ".git" folder from the path 
        $folder = $gitFolder.FullName -replace $gitFolderName, ""

        $url = git remote add origin https://INSTANCE.visualstudio.com/_git/PROJECT/$folder -replace "://", ("://{0}@" -f $gitcred)

        Write-Host "Performing git $cmd in folder: '$folder'..." -foregroundColor "green"

        # Go into the folder
        Push-Location $folder 

        # Perform the command within the folder
        git remote rm origin
        git remote add origin $url
        git checkout develop
        git checkout master
        git add .
        git commit -m "initial check in"
        git push -u origin --all

        # Go back to the original folder
        Pop-Location
    }

Pop-Location