Function Start-NiceHash {
    <#
.Synopsis
Start-NiceHash
.DESCRIPTION
Start-NiceHash
.EXAMPLE
Start-NiceHash
.NOTES
This requires the 'AutoStart' Mining to be set
#>

    [CmdletBinding()]
    Param (
        [String]$Directory = "$env:LOCALAPPDATA\Programs\NiceHash Miner",
        [String]$NiceHashMiner = "$Directory\NiceHashMiner.exe",
        [bool]$PrecisionSoftware = $true
    )

    Begin {
        If (!(Test-Path -Path $Directory)) {
            Write-Error -Message "Nicehash miner directory missing. Application may not be installed or corrupted. `nPlease reinstall or declare root directory using the `$Directory parameter."  -ErrorAction Sop
        }
        If (((Test-Path -Path "C:\Program Files\EVGA\Precision X1") -or (Test-Path -Path "C:\Program Files (x86)\EVGA\Precision X1")) -and ($PrecisionSoftware)) {
            Write-Verbose -Message "EVGA X1 Precision detected..."
            If (!(Get-Process -Name PrecisionX_x64 -ErrorAction SilentlyContinue)) {
                Write-Warning -Message "Precision not running. May require admin approval to open which could cause halt of script."
                Start-Process -FilePath "C:\Program Files\EVGA\Precision X1\PrecisionX_x64.exe"
            }
        }
        Else {
            Write-Warning -Message "Precision X1 will not be launched due to `$PrecisionSoftware being $false or software not being detected"
            $PrecisionSoftware = $false
        }
    }
    Process {
        if (!(Get-Process -Name app_nhm -ErrorAction SilentlyContinue)) {
            Start-Process $NiceHashMiner
            Write-Verbose -Message "Waiting for Nicehash miner to benchmark and initialize mining sequences..."
            [int]$i = 0
            do {
                $TotalGPUMemory = Get-TotalGPUMemoryUsage
                Write-Verbose -Message "Current GPU memory usage: $TotalGPUMemory%..."
                if ([percent]$TotalGPUMemory -gt 50) {
                    $i++
                    Write-Warning -message "$i : $TotalGPUMemory% : GPU memory spike detected..."
                }
                Start-Sleep -Seconds 5
            } until ($i -gt 2)
        }
        Else {
            Write-Verbose -Message "Nicehash application appears to be already open Attemping to restart Nicehash miner and it's dependencies..."
            try {
                Stop-Process -Name NiceHashMiner -ErrorAction SilentlyContinue
                Stop-Process -Name app_nhm -ErrorAction SilentlyContinue
            }
            catch {

            }
            Start-Process $NiceHashMiner
            Write-Warning "Waiting for Nicehash miner to benchmark and initialize mining sequences..."
            [int]$i = 0
            do {
                $TotalGPUMemory = Get-TotalGPUMemoryUsage
                if ($TotalGPUMemory -gt 50) {
                    $i++
                    Write-Warning -message "$i : GPU memory spike detected : $TotalGPUMemory%..."
                }
                Else {
                    Write-Verbose -Message "Current GPU memory usage: $TotalGPUMemory%..."
                }
                Start-Sleep -Seconds 5
            } until ($i -gt 2)
        }
        If ($PrecisionSoftware) {
            Write-Verbose -Message "Invoking GPU overclock global hotkey for Precision"
            Invoke-ControlF9Hotkey
        }
        Write-output "Mining initiated..."
    }
}