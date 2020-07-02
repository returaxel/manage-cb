<#
.SYNOPSIS
    Manage chromebooks with PowerShell... ft. GAM
.DESCRIPTION
    - Powershell script for handling chromebooks using GAM (https://github.com/jay0lee/GAM).
    - Used to change state (renable, disable, deprovision) or get info about managed chromebooks.
.PARAMETER action
    Input "reenable", "deprovision", "disable", "info".
.PARAMETER serialNumber
    Device serial number.
.PARAMETER optionalInfo
    Accepts optional GAM commands, ex; allFields, basic, OrgUnitPath.
.INPUTS
    None
.OUTPUTS
    None
.NOTES
    Version:        1.1
    Author:         returaxel
    Creation Date:  2020-07-02 
    Purpose/Change: added regex and lenght limit to lookup as to not accidentally delete / deprovision a range of devices
    Tested: 2020-07-02 
.EXAMPLE
    .\manage-cb.ps1 -action info -serialNumber 5ER14LN0 -optionalInfo orgunitpath
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

param(
    [Parameter(Position=1, Mandatory=$true)]
    [ValidateSet("reenable", "deprovision", "disable", "info"][string]$action,
    [Parameter(Position=2, Mandatory=$true)][string]$serialNumber,
    [Parameter(Position=3, Mandatory=$false,ValueFromRemainingArguments=$true)][psobject[]]$optionalInfo
)

# Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

# Local reference file
$localGsuiteReference = ".\LocalGsuiteReference.csv"

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function Get-SerialNumberCheck {
    <# This function has to be edited to match your devices' serialnumber length and format #>
    param (
        [Parameter(Mandatory=$true)][string]$serialNumber
    )

    $errorCounter = 0
    
    if ($serialNumber -notmatch '^([0-9]|[a-zA-Z]){10}$') {
        $errorCounter += 1
        Write-Host "Expected format is '^([0-9]|[a-zA-Z]){10}$'"  -BackgroundColor Black -ForegroundColor Red
    }

    if ($serialNumber.length -ne 10){
        $errorCounter += 1
        Write-Host "Expected length is 10" -BackgroundColor black -ForegroundColor Yellow
    }
    if ($errorCounter -ne 0) {
        Write-Host "------------------------------------------
|Errors encountered - terminating script |
------------------------------------------"
        break
    }
}

function Get-ChromebookManagement{
    param (
        [Parameter(Mandatory=$true)][String]$action,
        [Parameter(Mandatory=$true)][string]$sN,
        [Parameter(Mandatory=$false)][psobject[]]$optionalInfo # for info
    )

    switch ($action) {
        deprovision {gam update cros query $serialNumber action deprovision_retiring_device acknowledge_device_touch_requirement} 
        reenable    {gam update cros query $serialNumber action reenable}
        disable     {gam update cros query $serialNumber action disable}
        info        {gam info cros query $serialNumber fields serialNumber status $optionalInfo}
        default     {break}
    }
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

Get-SerialNumberCheck $serialNumber
Get-ChromebookManagement $action $serialNumber $optionalInfo