################################################################################
#
#
#    VSTS Release Definition Console
#     
#    AUTHOR: Keith C.
#
#    
#    SPECIAL THANKS:
#        - i2web
#
#
################################################################################


################################################################################

Function viewAllReleaseDefinitions ($Authentication) {

Write-Output "`n|----------------VIEW ALL RD----------------"

#Sets endpoint for definition api
$DefinitionEndpoint = "$($Authentication.vsrm)/_apis/release/definitions?api-version=4.0-preview.4"

#Get release definitions
$ReleaseDefinition = (Invoke-WebRequest -Headers @{Authorization = $Authentication.authorizationheader} -Uri $DefinitionEndpoint -Method 'GET' -ContentType 'application/json') | ConvertFrom-Json
Write-Output "`n"
$ReleaseDefinition.value
Write-Output "`n|--------------------------------------------`n"

}

################################################################################

Function viewOneReleaseDefinition ($Authentication) {

Write-Output "`n|----------------VIEW ONE RD----------------"


#Retrieve release definition IDs
$DefinitionEndpoint = "$($Authentication.vsrm)/_apis/release/definitions?api-version=4.0-preview.4"

#Get release definitions
$ReleaseDefinition = (Invoke-WebRequest -Headers @{Authorization = $Authentication.authorizationheader} -Uri $DefinitionEndpoint -Method 'GET' -ContentType 'application/json') | ConvertFrom-Json

$ReleaseDefinitionIDList = @{}
$RDValues = @()
foreach ($value in $ReleaseDefinition.value)
{
    $ReleaseDefinitionIDList.Add($value.name, $value.id)
    $RDValues += $value.id
}

$viewValid = $false

while (!($viewValid))
{
    Write-Output "`n|----------------RELEASE DEFINITIONS----------------`n|"
    Write-Output "| [ ID ] - RELEASE DEFINITION NAME`n|--------------------------------------------"
    foreach ($kvp in $ReleaseDefinitionIDList.GetEnumerator())
    {
        Write-Output "| [ $($kvp.Value) ] - $($kvp.Key)"
    }

    $DefinitionId = Read-Host "|`n| Select a release definition to view"
    
    if ($RDValues -contains $DefinitionId)
    {
        $viewValid = $true
    }
}

#Sets endpoint for definition api
$DefinitionEndpoint = "$($Authentication.vsrm)/_apis/release/definitions/$($DefinitionId)?api-version=4.0-preview.4"

#Get one release definition
$ReleaseDefinition = (Invoke-WebRequest -Headers @{Authorization = $Authentication.authorizationheader} -Uri $DefinitionEndpoint -Method 'GET' -ContentType 'application/json') | ConvertFrom-Json
Write-Output "`n`n|-----------------Output---------------------"
$ReleaseDefinition
Write-Output "`n|--------------------------------------------`n"


}

################################################################################

function createReleaseDefinition($Authentication){

Write-Output "`n|----------------CREATE RELEASE DEFINITION-----------------"

#Reads json file
$json = ConvertFrom-Json "$(Get-Content "$($PSScriptRoot)\Dependencies\releasedef.json")"


$DefinitionEndpoint = "$($Authentication.vsrm)/_apis/release/definitions?api-version=4.0-preview.4"


#Retrieves the Release Definition name and converts to API consumable format
$ReleaseDefinitionName = Read-Host "|`n| Enter a name for the new Release Definition"
$json.name = $ReleaseDefinitionName+" CD"
$jsonString=$json | ConvertTo-Json -Depth 100


#Create a release definition
Try
{
    $ReleaseDefinition = (Invoke-WebRequest -Headers @{Authorization = $Authentication.authorizationheader} -Uri $DefinitionEndpoint -Method 'POST' -ContentType 'application/json' -Body $jsonString)
    Write-Output "|`n| Release Definition created for $($ReleaseDefinitionName)`n|"
}
Catch
{
    Write-Output "|`n| Release Definition creation failed`n|"
}

Write-Output "|----------------------------------------------------------`n"

}

################################################################################


################################################################################

function updateReleaseDefinition($Authentication){

Write-Output "`n|----------------UPDATE RELEASE DEFINITION-----------------"

#Reads json file
$json = ConvertFrom-Json "$(Get-Content "$($PSScriptRoot)\Dependencies\updaterelease.json")"


$DefinitionEndpoint = "$($Authentication.vsrm)/_apis/release/definitions?api-version=4.0-preview.4"


#Update a release definition
Try
{
    $ReleaseDefinition = (Invoke-WebRequest -Headers @{Authorization = $Authentication.authorizationheader} -Uri $DefinitionEndpoint -Method 'PUT' -ContentType 'application/json' -Body $json)
    Write-Output "|`n| Release Definition updated`n|"
}
Catch
{
    Write-Output "|`n| Error updating Release Definition`n|"
}

Write-Output "|----------------------------------------------------------`n"

}

################################################################################


################################################################################

function deleteReleaseDefinition($Authentication){

    Write-Output "`n|----------------DELETE RELEASE DEFINITION-----------------"

    #Retrieve release definition IDs
    $DefinitionEndpoint = "$($Authentication.vsrm)/_apis/release/definitions?api-version=4.0-preview.4"

    #Get release definitions
    $ReleaseDefinition = (Invoke-WebRequest -Headers @{Authorization = $Authentication.authorizationheader} -Uri $DefinitionEndpoint -Method 'GET' -ContentType 'application/json') | ConvertFrom-Json

    $ReleaseDefinitionIDList = @{}
    $RDValues = @()
    foreach ($value in $ReleaseDefinition.value)
    {
        $ReleaseDefinitionIDList.Add($value.name, $value.id)
        $RDValues += $value.id
    }

    $viewValid = $false
    $DefinitionId

    while (!($viewValid))
    {
        Write-Output "`n|----------------RELEASE DEFINITIONS----------------`n|"
        Write-Output "| [ ID ] - RELEASE DEFINITION NAME`n|--------------------------------------------"
        foreach ($kvp in $ReleaseDefinitionIDList.GetEnumerator())
        {
            Write-Output "| [ $($kvp.Value) ] - $($kvp.Key)"
        }

        $readHost = Read-Host "|`n| Select a release definition to delete"
    
        if ($RDValues -contains $readHost)
        {
            $viewValid = $true
            $DefinitionId = $readHost
        }
    }

    #Confirm the deletion of the release definition
    $delete = $false
    Write-Output "|`n| Are you SURE you want to DELETE this Release Definition?"

    $confirmation = Read-Host "| [ y / N ] " 
    Switch ($confirmation) 
    { 
        Y {Write-Output "|`n| Deleting the Release Definition..."; $delete=$true} 
        N {Write-Output "|`n| Cancelling the deletion"; $doubleCheck=$true} 
        Default {Write-Output "|`n| Cancelling the deletion"; $PublishSettings=$false} 
    } 
   
    
    
    #Delete a release definition
    $DefinitionEndpoint = "$($Authentication.vsrm)/_apis/release/definitions/$($DefinitionId)/?api-version=4.0-preview.4"
    $ReleaseDefinition = (Invoke-WebRequest -Headers @{Authorization = $Authentication.authorizationheader} -Uri $DefinitionEndpoint -Method 'DELETE' -ContentType 'application/json')
    Write-Output "|`n| Release Definition deleted`n|"
    Write-Output "|----------------------------------------------------------`n"

}

################################################################################




$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"

#-----Login-----#
$Authentication = .\Functions\Authenticate.ps1


$end = $false
while (!($end))
{

    Write-Output "`n|----------------MAIN MENU----------------`n|"
    Write-Output "| [ 1 ] - View All Release Definitions"
    Write-Output "| [ 2 ] - View a Specific Release Definition"
    Write-Output "| [ 3 ] - Create a Release Definition"
    Write-Output "| [ 4 ] - Update a Release Definition"
    Write-Output "| [ 5 ] - Delete a Release Definition"
    Write-Output "| [ Q ] - Quit =("
    Write-Output "|`n|-----------------------------------------"
    $selector = Read-Host "`n Select an option"



    switch ( $selector )
    {
        1 { viewAllReleaseDefinitions($Authentication) }
        2 { viewOneReleaseDefinition($Authentication) }
        3 { createReleaseDefinition($Authentication) }
        4 { updateReleaseDefinition($Authentication) }
        5 { deleteReleaseDefinition($Authentication) }
        Q { Write-Output "`n Goodbye!"; $end = $true }
    }


}