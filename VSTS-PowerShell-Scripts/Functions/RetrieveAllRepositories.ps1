param(
    [Parameter(Mandatory)][string]
    $username,
    [Parameter(Mandatory)][string]
    $password,
    [Parameter(Mandatory)][string]
    $url
)

# Retrieve list of all repositories
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password)))
$headers = @{
    "Authorization" = ("Basic {0}" -f $base64AuthInfo)
    "Accept" = "application/json"
}

Add-Type -AssemblyName System.Web
$gitcred = ("{0}:{1}" -f  [System.Web.HttpUtility]::UrlEncode($username),$password)

$resp = Invoke-WebRequest -Headers $headers -Uri ("{0}/_apis/git/repositories?api-version=1.0" -f $url)
$json = convertFrom-JSON $resp.Content



#Populate and return object
$Repository = @{}
$Repository.Add("gitcred",$gitcred)
$Repository.Add("resp",$resp)
$Repository.Add("json",$json)

return $Repository