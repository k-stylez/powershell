param(
    [Parameter(Mandatory=$true)][array]
    $Authentication
)

$ProjectEndpoint = "$($Authentication.DefaultInstance)/_apis/projects?api-version=1.0"

$ProjectList = (Invoke-WebRequest -Headers @{Authorization = $Authentication.authorizationheader} -Uri $ProjectEndpoint -Method 'GET' -ContentType 'application/json') | ConvertFrom-Json

return $ProjectList