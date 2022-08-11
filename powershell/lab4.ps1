
function hardware
{
 Write-Output "System Hardware Information"
 gwmi -Class Win32_ComputerSystem | fl Description
}




function os
{
 Write-Output "Operating System Information"
 gwmi -Class Win32_OperatingSystem | fl Name, Version
}




function cpu
{
 Write-Output "System Processor Information"
 gwmi -Class win32_processor | fl Description, CurrentClockSpeed, NumberOfCores, @{n="L1CacheSize";e={switch($_.L1CacheSize){$null{$not="data unavailable"}};$not}}, L2CacheSize, L3CacheSize
}

                                                                                                                                                                          


function ram
{
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
"Total RAM: ${totalcapacity}GB"}


function disk {
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
        Where-Object {$_.IPEnabled -eq $True} |ft Description, Index, IPSubnet, @{n="DNSServerSearchOrder";e={switch($_.DNSServerSearchOrder){$null{$empty="data unavailable";$empty}};if($null -ne $_.DNSServerSearchOrder){$_.DNSServerSearchOrder}}}, @{n="DNSDomain";e={switch($_.DNSDomain){$null{$empty="data unavailable";$empty}};if($null -ne $_.DNSDomain){$_.DNSDomain}}}, IPAddress
}




 function gpu
 {
    "Video Card Information"
    gwmi -class win32_videocontroller | fl Name, Description
    $horizontal = (gwmi -Class Win32_videocontroller).CurrentHorizontalResolution  
    $vertical = (gwmi -Class win32_videocontroller).CurrentVerticalresolution
    "Current Resolution: $horizontal X $vertical"
}


hardware
os
cpu
ram
disk
network
gpu