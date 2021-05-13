Function Invoke-ControlF9Hotkey {
    <#
.Synopsis
Invoke-ControlF9Hotkey
.DESCRIPTION
Invoke-ControlF9Hotkey
.EXAMPLE
Invoke-ControlF9Hotkey
.NOTES
This requires the 'AutoStart' Mining to be set
#>

    [CmdletBinding()]
    Param (
    )

    Process {
        Add-Type -AssemblyName System.Windows.Forms
        [String]$Hotkey = [System.Windows.Forms.SendKeys]::SendWait("^{F9}")
        If (!(Get-Process -Name PrecisionX_x64 -ErrorAction SilentlyContinue)) {
            Write-Output  "EVGA X1 Precision not running or not installed. Global Hotkey execution will have no impact..."
        }
        Else {
            $Hotkey
            Write-Output "Global Hotkey Ctrl + F9 invoked"
        }
    }
}