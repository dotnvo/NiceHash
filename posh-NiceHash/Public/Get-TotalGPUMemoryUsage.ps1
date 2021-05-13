Function Get-TotalGPUMemoryUsage {
    <#
.Synopsis
Get-TotalGPUMemoryUsage
.DESCRIPTION
Get-TotalGPUMemoryUsage
.EXAMPLE
Get-TotalGPUMemoryUsage
.NOTES
#>

    [CmdletBinding()]
    Param (

    )

    Process {
        # May need to consider a process where there are more than 1 video card here but this currently assumes 1 external video card
        if ((Get-CimInstance -ClassName CIM_VideoController | Where-Object -FilterScript {$_.AdapterDACType -ne "Internal"})) {
        
            #Due to WMI/CIM instances returning values in a uint32 data type for this value, we can't use those more convienent methods. Registry has to be used.
            $TotalAvailableGPUMemory = $([math]::Round(((Get-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0*" -Name HardwareInformation.qwMemorySize)."HardwareInformation.qwMemorySize")) / 1MB)
            $TotalGPUMemoryInUse = $([math]::Round((((((Get-Counter -ErrorAction SilentlyContinue -Counter "\GPU Process Memory(*)\Local Usage").CounterSamples | Where-Object -Property CookedValue).CookedValue | Measure-Object -Sum).sum)) / 1MB))
            [int]$PercentGPUMemoryUsed = [System.Math]::Round(($TotalGPUMemoryInUse / $TotalAvailableGPUMemory)*100)
        }
        Write-Output $PercentGPUMemoryUsed
    }
}