param(
    [Parameter(Mandatory)][string]
    $gitcred,
    [Parameter(Mandatory)][array]
    $json,
    [Parameter(Mandatory)][string]
    $url,
    [Parameter(Mandatory)][string]
    $location
)

$ErrorActionPreference = "SilentlyContinue"

if (!(Test-Path "$($location)"))
{
    New-Item -ItemType directory –path "$($location)"
}


Push-Location $location

# Clone or pull all repositories
$initpath = get-location

foreach ($entry in $json.value) { 
    $name = $entry.name 

    $url = $entry.remoteUrl -replace "://", ("://{0}@" -f $gitcred)
    if(!(Test-Path -Path $name)) {
        git clone $url
    } else {
        set-location $name 
        git pull
        set-location $initpath
    }
}

Pop-Location

Write-Host "Done with repo clone"