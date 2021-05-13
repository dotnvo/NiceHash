Function Stop-NiceHash {
    <#
.Synopsis
Stop-NiceHash
.DESCRIPTION
Stop-NiceHash
.EXAMPLE
Stop-NiceHash
.NOTES
This requires the 'AutoStart' Mining to be set
#>

    [CmdletBinding()]
    Param (
        [String]$MinerPluginsDirectory = "$env:LOCALAPPDATA\Programs\NiceHash Miner\Miner_plugins"
    )

    Begin {
        $ErrorActionPreference = "SilentlyContinue"
        $RunningMiner = Get-Process | Where-Object -Property Path -like "*$MinerPluginsDirectory*" 
        If (!(Get-Process -Name PrecisionX_x64)) {
            Write-Warning -Message "Precision not running. May require admin approval to open which could cause halt of script."
            Start-Process -FilePath "C:\Program Files\EVGA\Precision X1\PrecisionX_x64.exe"
        }
    }
    Process {
        Stop-Process -Name NiceHashMiner
        Stop-Process -Name app_nhm
        Stop-Process -Name $RunningMiner.Name
        Invoke-ControlF1Hotkey
        if (!((Get-Process -Name app_nhm) -and (Get-Process -Name NiceHashMiner) -and (Get-Process -Name $RunningMiner.Name))) {
            Write-Output "Nicehash app and miner have been closed."
        } Else {
            Write-Output "Nicehash miner or app may still be running. `nManual intervention may be required."
        }
    }
}