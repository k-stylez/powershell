param(
    [Parameter(Mandatory=$false)][string]
    $project
)

Get-Content (".\Login\auth.config") | foreach-object -begin {$h=@{}} -process { 
    $k = [regex]::split($_,'='); 
    if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { 
        $h.Add($k[0], $k[1]) 
    } 
}

#Login
$VstsInstance = $h.Get_Item("VstsInstance")
$VsrmInstance = $h.Get_Item("VsrmInstance")
$FeedInstance = $h.Get_Item("FeedInstance")
$user = $h.Get_Item("Username")
$pass = $h.Get_Item("Password")


#Build Auth Header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$pass)))
$headers = @{
    "Authorization" = ("Basic {0}" -f $base64AuthInfo)
    "Accept" = "application/json"
}
$Password = ":$($pass)"
$EncodedCredentials = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($Password))
$AuthorizationHeader = "Basic $EncodedCredentials"


#Create project URL array
$ProjectUrls = @("/Project%20Name", "/Other%20Project", "/Add%20More%20Projects")

#Select a project

if(!($project))
{
    $valid = $false
    while ($valid -eq $false)
    {
        $selection = Read-Host "`n[ 1 ] - Project One `n[ 2 ] - Project Two `n[ 3 ] - Project Three `n[ 4 ] - Project Four `n[ 5 ] - Project Five `nEnter a project number"

        if ($selection -eq 1)
        {
            $project = "/Project%20Name"
            $valid = $true
        }
        elseif ($selection -eq 2)
        {
            $project = "/Project%20Name"
            $valid = $true
        }
        elseif ($selection -eq 3)
        {
            $project = "/Project%20Name"
            $valid = $true
        }
        elseif ($selection -eq 4)
        {
            $project = "/Project%20Name"
            $valid = $true
        }
        elseif ($selection -eq 5)
        {
            $project = "/Project%20Name"
            $valid = $true
        }
        else
        {
            Write-Output "`nError: Invalid project number!"
        }
    }
}
else
{
    Write-Output "Project selection bypassed"
    Write-Output "Project set to [ $($project) ]"
}


#Set URLs
$url = $VstsInstance+$project
$vsrm = $VsrmInstance+$project
$FeedInstance = $FeedInstance+"/DefaultCollection"
$DefaultInstance = $VstsInstance+"/DefaultCollection"
$defaultCollection = $VstsInstance+"/DefaultCollection"+$project




#Populate and return object
$Authentication = @{}
$Authentication.Add("VstsInstance", $VstsInstance)
$Authentication.Add("vsrm", $vsrm)
$Authentication.Add("VsrmInstance", $VsrmInstance)
$Authentication.Add("FeedInstance", $FeedInstance)
$Authentication.Add("DefaultInstance", $DefaultInstance)
$Authentication.Add("url",$url)
$Authentication.Add("defaultCollection",$defaultCollection)
$Authentication.Add("project", $project)
$Authentication.Add("username",$user)
$Authentication.Add("password",$pass)
$Authentication.Add("base64AuthInfo",$base64AuthInfo)
$Authentication.Add("headers",$headers)
$Authentication.Add("authorizationheader",$AuthorizationHeader)
$Authentication.Add("ProjectUrls",$ProjectUrls)

return $Authentication