param(
    [Parameter(Mandatory=$true)][string]
    $location
)

Push-Location $location

#Get List of Repository Names
$repoNames = &dir -Directory <#-Filter NAME.*#>
if ($repoNames)
{
    return $repoNames
}
else
{
    Write-Error "No directories matching the filter specifications were found"
}

Pop-Location