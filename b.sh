#!/bin/bash
#
white="\033[1;32m"  # Bright Green
red="\033[0;31m"  # Normal Red
reset="\033[0;33m"  # Normal Yellow
echo " "
echo -e "${white}------------------------------------------------------------------System Information--------------------------------------------------------------${reset}"
echo -e "${red}Hostname:${reset}\t\t"`hostname -f`
echo -e "${red}IP Address:${reset}\t\t"`hostname -I`
echo -e "${red}Uptime:${reset}\t\t"`uptime | awk '{print $3,$4}' | sed 's/,//'`
echo -e "${red}Machine Type:${reset}\t\t"`vserver=$(lscpu | grep Hypervisor | wc -l); if [ $vserver -gt 0 ]; then echo "VM"; else echo "Physical"; fi`
echo -e "${red}Product Name:${reset}\t\t"`cat /sys/class/dmi/id/product_name`
echo -e "${red}Operating System:${reset}\t\t"`cat /etc/redhat-release`
echo -e "${red}Kernel:${reset}\t\t"`uname -r`
echo -e "${red}Architecture:${reset}\t\t"`arch`
echo -e "${red}Processor Name:${reset}\t\t"`awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//'`
echo -e "${red}CPU Cores:${reset}\t\t"`grep -c ^processor /proc/cpuinfo`
echo -e "${red}Total RAM:${reset}\t\t"`free -h | awk '/^Mem:/{print $2}'`
echo -e "${red}Disk Usage:${reset}\t\t"
df -h | grep '^/dev/'
echo -e "${red}Load Average:${reset}\t\t"`uptime | awk -F'load average:' '{ print $2 }'`
echo " "
echo -e "${white}------------------------------------------------------------------Resource Usage--------------------------------------------------------------${reset}"
echo -e "${red}CPU Usage:${reset}\t\t"`awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1) "%";}' <(grep 'cpu ' /proc/stat) <(sleep 1; grep 'cpu ' /proc/stat)`
echo -e "${red}Memory Usage:${reset}\t\t"`free | awk '/Mem/{printf("%.2f%"), $3/$2*100}'`
echo -e "${red}Swap Usage:${reset}\t\t"`free | awk '/Swap/{printf("%.2f%"), $3/$2*100}'`
echo -e "${red}Top 5 Processes by CPU Usage:${reset}"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -6
echo -e "${red}Top 5 Processes by Memory Usage:${reset}"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -6
echo -e "${red}Disk I/O:${reset}\t\t"
iostat -x | head -10
echo -e "${red}Network Usage:${reset}\t\t"
netstat -i | grep -vE '^Kernel|Iface|lo'
echo -e "${red}Active Network Connections:${reset}"
netstat -ant | grep 'ESTABLISHED'
echo -e "${red}Swap Activity:${reset}"
vmstat 1 5
echo -e "${red}Zombie Processes:${reset}\t\t"
ps aux | awk '{ if ($8 == "Z") print $0; }'
echo -e "${red}System Temperature:${reset}\t\t"
sensors | grep 'Core'
echo " "
