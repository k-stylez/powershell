$ErrorActionPreference = "SilentlyContinue"

#-----Login-----#
$Authentication = .\Functions\Authenticate.ps1

#-----Repos-----#
$Repository = .\Functions\RetrieveAllRepositories.ps1 -username $Authentication.username -password $Authentication.password -url $Authentication.url

#$location = Read-Host "Enter the location of the repository: "
$location = "d:\gittest"


#-----Clone-----#
.\Functions\RepoClone.ps1 -gitcred $Repository.gitcred -json $Repository.json -url $Authentication.url -location $location
Pop-Location


#The root directory
$baseDir = "."

#Get a list of directories from repos
cd $PSScriptRoot
$repoNames = .\Functions\GetRepoNames.ps1 -location $location
Pop-Location

Push-Location $location

#Checkouts
ForEach ($repoName in $repoNames) {

        # Go into the folder
        Push-Location $repoName
        Write-Host "Repo Name: " $repoName

        git fetch --all
        git pull --all

        git remote rm origin
        ##CHANGE YOUR VSTS INSTANCE INFO HERE##
        git remote add origin https://INSTANCE.visualstudio.com/PROJECT/_git/git-test

        $branches = git branch -a
        
        foreach($branch in $branches)
        {
            $branch = $branch -creplace '^[^_]*\s'
            if($branch.StartsWith("remote"))
            {
                $branch = $branch -creplace '^[^_]*\/[^_]*\/'                
                git checkout -q -b "$($branch)"
                Write-Output "REPLACED - |$($branch)|"
            }
            else
            {
                #git checkout -q "$($branch)"
                Write-Output "Nope"
            }
        }

        git branch -a
        git add .
        git commit -m "initial commit ***NO_CI***" | Out-Null
        git push -q -u origin --all
        Write-Output "GIT PUSHED"

        #Return to original folder
        Pop-Location
}

Pop-Location

