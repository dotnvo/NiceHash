Function Invoke-ControlF1Hotkey {
    <#
.Synopsis
Invoke-ControlF1Hotkey
.DESCRIPTION
Invoke-ControlF1Hotkey
.EXAMPLE
Invoke-ControlF1Hotkey
.NOTES

#>

    [CmdletBinding()]
    Param (
    )

    Process {
        Add-Type -AssemblyName System.Windows.Forms
        [String]$Hotkey = [System.Windows.Forms.SendKeys]::SendWait("^{F1}")
        If (!(Get-Process -Name PrecisionX_x64 -ErrorAction SilentlyContinue)) {
            Write-Output "Precision not running. Global Hotkey execution will have no impact..."
        }
        Else {
            $Hotkey
            Write-Output "Global Hotkey Ctrl + F1 invoked"
        }
    }
}