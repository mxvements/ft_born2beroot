# USE BASH TO EXECUTE SCRIPT
#!bin/bash

# 	1	ARCHITECTURE
arch=$(uname -a)

#	2	CPU PHYSICAL
cpup=$(grep "physical id" /proc/cpuinfo | wc -l)

#	3	CPU VIRTUAL
cpuv=$(grep "processor" /proc/cpuinfo | wc -l)

#	4	RAM USE
ramuse=$(free --mega | awk '$1 == "Mem:" {printf $3}')
ramtot=$(free -mega | awk '$1 == "Mem:" {printf $2}')
ramperc=$(free --mega | awk '$1 == "Mem:" {printf("(%2.f%%)\n", $3/$2*100)}')

#	5	DISK USE
memuse=$(df -m | grep "/dev/" | grep "/boot" | awk '{memuse += $3} END {print memuse}')
memtot=$(df -m | grep "/dev/" | grep "/boot" | awk '{memtot += $2} END {print memtot}')
memperc=$(df -m | grep -v "/dev/" | grep "/boot" | awk '{memuse += $3} {memtot += $2} END {printf("(%.2f%%)\n", memuse/memtot*100)}')

#	6	USE% ON DISK / CPU LOAD
diskuse=$(vmstat 1 4 | tail -1 | awk'{print $15}')
diskop=$(expr 100 - $diskuse)
diskload=$(printf "%.1f" $diskop)

#	7	LAST BOOT
lastboot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

#	8	LVM USE
lvmuse=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

#	9	TCP CONECTIONS
tcpc=$(ss -ta | grep -v "LISTEN" | grep -v "State" | wc -l)

#	10	NUM USERS
usrs=$(users | wc -l)

#	11	IP & MAC ADDRESS
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

#	12	NUM SUDO COMMANDS EXECUTED
sudocmnds=$(journalctl _COMM=sudo | grep "COMMAND" | wc -l)

#	PRINT ON ALL USERS TERMINALS
wall "	#Architecture: $arch
		#CPU Physical: $cpup
		#vCPU: $cpuv
		#Memory Usage: $ramuse/${ramtot}MB ($ramperc%)
		#Disk Usage: $memuse/${memtot} ($memperc%)
		#CPU Load: $diskload%
		#Last Boot: $lastboot
		#LVM Use: $lvmuse
		#Connections TCP: $tcpc ESTABLISHED
		#User Log: $usrs
		#Network: IP $ip ($mac)
		#Sudo: $sudocmnds cmd
	 "