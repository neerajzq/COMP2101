$env:path += ";$home/documents/github/comp2101/powershell"

new-item -path alias:np -value notepad


function welcome
{
    "Welcome back my Boss $env:computername sir $env:username"
    $now = get-date -format 'HH:MM tt on dddd'
    "It is $now."
}




function get-cpuinfo
{
    Get-CimInstance CIM_Processor | select manufacturer, CurrentClockSpeed, MaxClockSpeed, NumberOfCores
}




function get-mydisks 
{
    Get-Disk | ft Manufacturer, Model, SerialNumber, FirmwareVersion, Size
}




function system 
{


 Write-Output "System Hardware Information"
 gwmi -Class Win32_ComputerSystem | fl Description





 Write-Output "Operating System Information"
 gwmi -Class Win32_OperatingSystem | fl Name, Version





 Write-Output "System Processor Information"
 gwmi -Class win32_processor | fl Description, CurrentClockSpeed, NumberOfCores, @{n="L1CacheSize";e={switch($_.L1CacheSize){$null{$not="data unavailable"}};$not}}, L2CacheSize, L3CacheSize

 
 

    "Video Card Information"
    gwmi -class win32_videocontroller | fl Name, Description
    $horizontal = (gwmi -Class Win32_videocontroller).CurrentHorizontalResolution  
    $vertical = (gwmi -Class win32_videocontroller).CurrentVerticalresolution
    "Current Resolution: $horizontal X $vertical"




Write-Output "RAM Information"
$totalcapacity = 0
gwmi -Class win32_physicalmemory |
  foreach { 
    New-Object -TypeName psObject -Property @{ 
      Vendor = $_.Manufacturer
      Description = $_.Description
      "Size(GB)" = $_.Capacity/1gb
      Bank = $_.BankLabel
      Slot = $_.DeviceLocator
      }
$totalcapacity += $_.capacity/1gb} | ft
"Total RAM: ${totalcapacity}GB"
}




function disks 
{
  $diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Location=$partition.deviceid
                                                               Drive=$logicaldisk.deviceid
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                               "Free space(GB)"=$logicaldisk.freespace/1gb -as [int] 
                                                               "Free space in %"=100*$logicaldisk.freespace/$logicaldisk.size  -as [int]
                                                               } | ft
           }
      }
  }}




function network {
    get-ciminstance win32_networkadapterconfiguration |
        Where-Object {$_.IPEnabled -eq $True} |ft Description, Index, IPSubnet, @{n="DNSDomain";e={switch($_.DNSDomain){$null{$empty="data unavailable";$empty}};if($null -ne $_.DNSDomain){$_.DNSDomain}}} , @{n="DNSServerSearchOrder";e={switch($_.DNSServerSearchOrder){$null{$empty="data unavailable";$empty}};if($null -ne $_.DNSServerSearchOrder){$_.DNSServerSearchOrder}}}, IPAddress
}



