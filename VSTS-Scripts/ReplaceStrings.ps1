param(
    [Parameter][string]
    $json
)

#REPLACE ALL INSTANCES OF A GIVEN STRING IN A JSON



#ENTER A FILE NAME HERE
if(!($json))
{
    $json = Read-Host "Enter the absolute path to the JSON file you wish to edit"
}

$initial = Read-Host 'Enter what string you would like to search for and replace'
$replacement = Read-Host 'Enter what you would like to replace it with'
$json = (Get-Content "$($json)") -replace "$($initial)", "$($replacement)" | ConvertFrom-Json


$jsonString=$json | ConvertTo-Json -Depth 100
$jsonString >> output.json