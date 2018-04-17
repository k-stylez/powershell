param(
    [Parameter(Mandatory)][array]
    $Authentication
)


$QueueEndpoint = "$($Authentication.DefaultCollection)/_apis/distributedtask/queues?api-version=3.0-preview.1"

$Queues = (Invoke-WebRequest -Headers @{Authorization = $Authentication.authorizationheader} -Uri $QueueEndpoint -Method 'GET' -ContentType 'application/json') | ConvertFrom-Json

$Return = $Queues.value

return $Return