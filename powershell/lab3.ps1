﻿Get-CimInstance win32_networkadapterconfiguration | Where-Object IPEnabled | Select-Object Description, Index, IPAddress, IPSubnet, DNSDomain | ft
