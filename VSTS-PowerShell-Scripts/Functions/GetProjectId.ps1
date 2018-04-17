param(
    [Parameter(Mandatory=$true)][string]
    $project,
    [Parameter(Mandatory=$true)][string]
    $VstsInstance,
    [Parameter(Mandatory=$true)][string]
    $AuthHeader
)


$ProjectEndpoint = "$($VstsInstance)/DefaultCollection/_apis/projects/$($project)?api-version=1.0"

$ReturnedProject = (Invoke-WebRequest -Uri $ProjectEndpoint -Method 'GET' -Headers @{Authorization = $AuthHeader} -ContentType 'application/json') | ConvertFrom-Json

$projectId = $ReturnedProject.id

return $projectId