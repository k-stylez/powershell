[CmdletBinding()]
param(
    [Parameter][string]
    $ReleaseDefinitionName
)

$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"

#-----Login-----#
$Authentication = .\Functions\Authenticate.ps1

#Sets endpoint for definition api
$DefinitionEndpoint = "$($Authentication.defaultCollection)/_apis/release/definitions?api-version=4.0-preview.4"

#Reads json file
$json = ConvertFrom-Json "$(Get-Content "$($PSScriptRoot)\Dependencies\releasedef.json")"


if(!($ReleaseDefinitionName))
{
    $ReleaseDefinitionName = Read-Host "Enter a name for the new Release Definition"
}


#Retrieves the Release Definition name and converts to API consumable format
$json.name = $ReleaseDefinitionName+" CD"
$jsonString=$json | ConvertTo-Json -Depth 100


#create a release definition
$ReleaseDefinition = (Invoke-WebRequest -Headers @{Authorization = $Authentication.authorizationheader} -Uri $DefinitionEndpoint -Method 'POST' -ContentType 'application/json' -Body $jsonString)
Write-Output "Release Definition created for $($ReleaseDefinitionName)"