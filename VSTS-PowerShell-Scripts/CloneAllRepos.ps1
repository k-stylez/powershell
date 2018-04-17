$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"

$end = $false

while(!($end))
{

    #-----Login-----#
    $Authentication = .\Functions\Authenticate.ps1

    #-----Repos-----#
    $Repository = .\Functions\RetrieveAllRepositories.ps1 -username $Authentication.username -password $Authentication.password -url $Authentication.url

    $location = Read-Host "Enter the location of the repository"

    #-----Clone-----#
    .\Functions\RepoClone.ps1 -gitcred $Repository.gitcred -json $Repository.json -url $Authentication.defaultCollection -location $location


    $readHost = Read-Host "`nWould you like to clone repositories from another project? [ y / N ]"

    switch ($readHost)
    {
        Y { $end = $false }
        N { $end = $true; "Exiting script." }
        Default { $end = $true; "Exiting script." }
    }
}