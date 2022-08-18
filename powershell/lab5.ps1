Param 
( 
    [switch]$system, 
    [switch]$disks,
    [switch]$network
)



if ($system)
{
    
    system
} 
elseif ($disks) 
{
    disk 
}
 elseif ($network) 
{
    network 
}

else
{
    welcome
    get-cpuinfo
    get-mydisks
    system
    network
    disks
}