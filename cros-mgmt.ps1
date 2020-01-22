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
    [Parameter(Position=1, Mandatory=$true)]
    [ValidateSet("reenable", "deprovision", "disable", "info")][string]$action,
    [Parameter(Position=2, Mandatory=$true)][string]$serialNumber,
    [Parameter(Position=3, Mandatory=$false,ValueFromRemainingArguments=$true)][psobject[]]$optionalInfo
)

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

#-----------------------------------------------------------[Functions]------------------------------------------------------------

function Set-State{
    param (
        [Parameter(Mandatory=$true)][String]$action,
        [Parameter(Mandatory=$true)][string]$sN,
        [Parameter(Mandatory=$false)][psobject[]]$optionalInfo
    )
    switch ($action) {
        deprovision {gam update cros query $serialNumber action deprovision_retiring_device acknowledge_device_touch_requirement}
        disable     {gam update cros query $serialNumber action disable}
        reenable    {gam update cros query $serialNumber action reenable}
        info        {gam info cros query $serialNumber fields serialNumber status $optionalInfo}
        default     {break}
    }

}

#-----------------------------------------------------------[Execution]------------------------------------------------------------ne

Set-State $action $serialNumber $optionalInfo

