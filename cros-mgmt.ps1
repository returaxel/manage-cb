<#
.SYNOPSIS
    Manage chromebooks with PoSH ft. GAM
.DESCRIPTION
    - Powershell script for handling chromebooks using GAM (https://github.com/jay0lee/GAM).
    - Used to change state (renable, disable, deprovision) or get info about managed chromebooks.
.PARAMETER action
    Input "reenable", "deprovision", "disable", "info".
.PARAMETER serialNumber
    Device serial number.
.PARAMETER optionalInfo
    Accepts optional GAM commands, ex; allFields, basic, OrgUnitPath.
.PARAMETER logSavePath
    Specify a new location, ex: "C:\temp", or leave blank. Default save location is script root. 
.INPUTS
    None
.OUTPUTS
    None
.NOTES
    Version:        1.0
    Author:         returaxel
    Creation Date:  Date
    Purpose/Change: re-release
  
.EXAMPLE
    .\gam_reenable_disable.ps1 -action info -serialNumber 5ER14LN0 -optionalInfo basic

#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

param(
    [Parameter(Position=1)]
    [ValidateSet("reenable", "deprovision", "disable", "info")][string]$action,
    [Parameter(Position=2, Mandatory=$true)][string]$serialNumber,
    [Parameter(Position=3, Mandatory=$false,ValueFromRemainingArguments=$true)][psobject[]]$optionalInfo
    #[Parameter(Position=4, Mandatory=$false)][string]$logSavePath
)

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function Set-Log{
    param (
        [Parameter(Mandatory=$false)][string]$logSavePath,
        [Parameter(Mandatory=$true)][string]$action,
        [Parameter(Mandatory=$true)][string]$serialNumber
    )

    [string]$dateTime = Get-Date                                # Set date
    [string]$deviceInfo = "$dateTime, $serialNumber, $action"   # Set logging info

    if ($logSavePath.gettype().name -eq 'String' -and $logSavePath.length -eq 0) {
        $logSavePath = $PSScriptRoot
    } 
    elseif ((Test-Path $logSavePath) -ne $true) {
        mkdir > $null -Path $logSavePath
    }
    try {
        $deviceInfo | Out-File -FilePath $logSavePath\cros-log.txt -Append
    }catch{
        Write-Host "Could not write to $logSavePath\cros-log.txt" -f Yellow
    } 
}

function Get-SerialNumber {
    param (
        [Parameter(Mandatory=$true)]$serialNumber
    )
        gam cros_sn $serialNumber print
}

function Set-State{
    param (
        [Parameter(Mandatory=$true)][String]$action,
        [Parameter(Mandatory=$true)][string]$sN,
        [Parameter(Mandatory=$false)][psobject[]]$optionalInfo
    )
    switch ($action) {
        deprovision {gam update cros $sN action deprovision_retiring_device acknowledge_device_touch_requirement}
        disable     {gam update cros $sN action disable}
        reenable    {gam update cros $sN action reenable}
        info        {gam info cros $sN fields serialNumber status $optionalInfo}
        default     {break}
    }

}

#-----------------------------------------------------------[Execution]------------------------------------------------------------
 
#Set-Log $logSavePath $action $serialNumber 
$sN = Get-SerialNumber $serialNumber
Set-State $action $sN $optionalInfo

