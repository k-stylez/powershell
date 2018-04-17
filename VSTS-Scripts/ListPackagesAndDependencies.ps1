$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"

#-----Login-----#
$Authentication = .\Functions\Authenticate.ps1

#Get a list of packages
$PackagesEndpoint = "$($Authentication.FeedInstance)/_apis/packaging/feeds/Packages/packages?api-version=2.0-preview.1"

#Fires package list query and outputs to a file
if (Test-Path "$($PSScriptRoot)'\Packages.txt")
{
    Remove-Item –path "$($PSScriptRoot)\Packages.txt"
}
$Packages = (Invoke-WebRequest -Uri $PackagesEndpoint -Method 'GET' -Headers @{Authorization = $Authentication.authorizationheader} -ContentType 'application/json') | ConvertFrom-Json
$Packages.value |  Out-File -FilePath "$($PSScriptRoot)\Packages.txt"


#Get all package and version IDs : Outputs to separate files
if (Test-Path "$($PSScriptRoot)\VersionIds.json")
{
    Remove-Item –path "$($PSScriptRoot)\VersionIds.json"
}
$VersionIdList = $Packages.value | Select -ExpandProperty versions | Select -Property id
$VersionIdList | Out-File -FilePath "$($PSScriptRoot)\VersionIds.json"

if (Test-Path "$($PSScriptRoot)\PackageIds.json")
{
    Remove-Item –path "$($PSScriptRoot)\PackageIds.json"
}
$PackageIdList = $Packages.value | Select -Property id
$PackageIdList |  Out-File -FilePath "$($PSScriptRoot)\PackageIds.json"


#Get individual package and version IDs and does not include lines with spaces : Stores in arrays
Get-Content "PackageIds.json" | ForEach-Object -begin {$PackageId=@()} -process { 
    $b = ($_); 
    if(($b.CompareTo("") -ne 0) -and ($b.StartsWith("id") -ne $True) -and ($b.StartsWith("-") -ne $True)) { 
        $PackageId+=$b 
    } 
}


Get-Content "VersionIds.json" | ForEach-Object -begin {$VersionId=@()} -process { 
    $b = ($_); 
    if(($b.CompareTo("") -ne 0) -and ($b.StartsWith("id") -ne $True) -and ($b.StartsWith("-") -ne $True)) { 
        $VersionId+=$b 
    } 
}


#Combines the Dependencies with the Package List using a counter to keep track of each package
#An empty output file is created then filled : Checks for existing file and removes if exists
if (!(Test-Path -path ".\Output" ))
{
    md .\Output
}

$OutputFile = "$($PSScriptRoot)\Output\PackagesAndDependencies.txt"

if (Test-Path $OutputFile)
{
    Remove-Item –path $OutputFile
}
New-Item $OutputFile -ItemType file


$counter=0;    
$data = get-content "$($PSScriptRoot)\Packages.txt"

foreach($line in $data)
{
   if($line.StartsWith('_links'))
   {
        $p = $PackageId[$counter];
        $v = $VersionId[$counter];

        $DependenciesEndpoint = "$($Authentication.FeedInstance)/_apis/packaging/feeds/Packages/packages/$($p)/versions/$($v)?api-version=2.0-preview.1&includeUrls=false"
        
        Try
        {
            $Dependencies = (Invoke-WebRequest -Uri $DependenciesEndpoint -Method 'GET' -Headers @{Authorization = $Authentication.authorizationheader} -ContentType 'application/json') | ConvertFrom-Json
            Add-Content $OutputFile "dependencies   :"
            Add-Content $OutputFile $Dependencies.dependencies
            Add-Content $OutputFile " "
            $counter++;
        }
        Catch
        {
            echo $_.Exception.GetType().FullName, $_.Exception.Message
        }
       
    }
    else
    {
        Add-Content $OutputFile $line
    }
}


#Clean-up temporary files
Remove-Item –path "$($PSScriptRoot)\PackageIds.json"
Remove-Item –path "$($PSScriptRoot)\VersionIds.json"
Remove-Item –path "$($PSScriptRoot)\Packages.txt"