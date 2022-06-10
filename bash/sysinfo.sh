#!/bin/bash

# sysinfo.sh - a script to display information about a computer

#Use an output template, with a cat command or something similar that has embedded variables for your report data

echo "
Report for $(hostname)
======================
FQDN: $(hostname -f)
Operating System name and version: $(lsb_release -d)
IP Address: $(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
Root Filesystem Free Space: $(df -h / | grep / | awk '{print $4}')
======================
"
