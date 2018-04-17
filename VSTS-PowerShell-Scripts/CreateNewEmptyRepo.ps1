#-----Login-----#
$Authentication = .\Functions\Authenticate.ps1


#Get ProjectID to designate where to create the new repository
$projectId = .\Functions\GetProjectId.ps1 -project $Authentication.project -VstsInstance $Authentication.VstsInstance -AuthHeader $Authentication.authorizationheader
$ProjectEndpoint = "$($Authentication.VstsInstance)/DefaultCollection/$($Authentication.project)/_apis/git/repositories/?api-version=1.0"


$name = Read-Host "`nEnter the new repository's name"
$projectTemplate = ConvertFrom-Json "$(Get-Content "$($PSScriptRoot)\Dependencies\project.json")"
$projectTemplate.name = $name

# --- Make a JSON body to POST and create the repository

$body = @{
name = $name
project = @{
    id = $projectId
    }
defaultBranch = "refs/heads/develop"
} | ConvertTo-Json


$ReturnedProject = (Invoke-WebRequest -Uri $ProjectEndpoint -Method 'POST' -Headers @{Authorization = $Authentication.authorizationheader} -ContentType 'application/json' -Body $body)
Write-Output "Repository $($name) creation finished"