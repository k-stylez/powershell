$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"

#-----Login-----#
$Authentication = .\Functions\Authenticate.ps1

#get a list of releases
$ReleasesEndpoint = "$($Authentication.vsrm)/_apis/release/definitions"
$ReleasesEndpoint

$Releases = (Invoke-WebRequest -Uri $ReleasesEndpoint -Method 'GET' -Headers @{Authorization = $Authentication.authorizationheader} -ContentType 'application/json') | ConvertFrom-Json

#$Releases.value | Select -ExpandProperty name
$ReleaseDefinitionNames = $Releases.value | Select -ExpandProperty name | ForEach-Object { $_ -replace ' CD', '' }

#get a list of builds
$BuildEndpoint = "$($Authentication.url)/_apis/build/definitions?api-version=2.0"
$BuildEndpoint

$Builds = (Invoke-WebRequest -Uri $BuildEndpoint -Method 'GET' -Headers @{Authorization = $Authentication.authorizationheader} -ContentType 'application/json') | ConvertFrom-Json

#$Builds.value | Select -ExpandProperty name
$BuildDefinitionNames = $Builds.value | Select -ExpandProperty name | ForEach-Object { $_ -replace ' CI', '' }

$BuildsWithoutReleases = $BuildDefinitionNames | ?{$ReleaseDefinitionNames -notcontains $_}
$ReleasesWithoutBuilds = $ReleaseDefinitionNames | ?{$BuildDefinitionNames -notcontains $_}

Write-Output "Builds Without Releases `n---------------------------------------"
$BuildsWithoutReleases
#Write-Output 'Releases without Builds'
#$ReleasesWithoutBuilds    