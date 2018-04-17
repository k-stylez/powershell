$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"


$Authentication = .\Functions\Authenticate.ps1

$BuildDefinitionUrl = "$($Authentication.defaultCollection)/_apis/build/definitions"

$BuildDefinitions = (Invoke-WebRequest -Headers @{Authorization = $Authentication.authorizationheader} -Uri $BuildDefinitionUrl -Method 'GET' -ContentType 'application/json') | ConvertFrom-Json

$BuildDefinitionNames = $BuildDefinitions.value | Select -ExpandProperty name | ForEach-Object { $_ -replace ' CI', '' }

$BuildDefinitionNames