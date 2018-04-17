#-----Login-----#
$Authentication = .\Functions\Authenticate.ps1

#-----Repos-----#
$Repository = .\Functions\RetrieveAllRepositories.ps1 -username $Authentication.username -password $Authentication.password -url $Authentication.url

$location = Read-Host "Enter the location of the repository: "

#-----Clone-----#
.\Functions\RepoClone.ps1 -gitcred $Repository.gitcred -json $Repository.json -url $Authentication.url -location $location
Pop-Location


#The root directory
$baseDir = "."
#yaml template with change
$destFileName = ".vsts-ci.yml"

#Get a list of directories from repos
$repoNames = .\Functions\GetRepoNames.ps1 -location $location
Pop-Location

Push-Location $location

#Update Yaml Files
ForEach ($repoName in $repoNames) {

        # Go into the folder
        Push-Location $repoName
        Write-Host "Repo Name: " $repoName

        #Replace yaml in repo with new yaml
        Copy-Item -Path "$($PSScriptRoot)\ymls\package\.vsts-ci.yml" -Destination "$destFileName" -Force 
        Write-Host "updated yaml"

        #add the yaml
        #git add .
        Write-Host "did git add"

        #commit the yaml
        #git commit -m "Updatd YAML Build File ***NO_CI***"
        Write-Host "did commit"

        # push the change to VSTS repo
        #git push origin develop
        Write-Host "pushed branch to remote"  

        #Return to original folder
        Pop-Location
}

Pop-Location

