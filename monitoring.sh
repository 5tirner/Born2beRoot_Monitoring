arch=$(uname -a)
pc=$(grep "physical id" /proc/cpuinfo | wc -l)
vc=$(grep processor /proc/cpuinfo | wc -l)
free_ram=$(free -h | awk '$1 == "Mem:" {print $2}')
used_ram=$(free -h | awk '$1 == "Mem:" {print $3}')
percentage_ram=$(free -h | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
free_disk=$(df -Bg | grep dev | grep -v boot | awk '{ft += $2} END {print ft}')
used_disk=$(df -Bm | grep dev | grep -v boot | awk '{ut += $3} END {print ut}')
percentage_disk=$(df -Bm | grep dev | grep -v boot | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')
cpu_loading=$(top -bn1 | grep Cpu | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
last_reboot=$(who -b | awk '$1 == "system" {print $3 " " $4}')
lvmt=$(lsblk | grep lvm | wc -l)
lvmu=$(if [ $lvmt -eq 0 ]; then echo no; else echo yes; fi)
ctcp=$(cat /proc/net/sockstat | awk '$1 == "TCP:" {print $3}')
ulog=$(users | wc -w)
ip=$(hostname -I)
mac=$(ip link show | awk '$1 == "link/ether" {print $2}')
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "	#Architecture: $arch
	#CPU physical: $pc
	#CPU virtual: $vc
	#Memory Usage: $usedram/${free_ram}MB ($percentage_ram%)
	#Disk Usage: $useddisk/${free_disk}Gb ($percentage_disk%)
	#CPU load: $cpu_loading
	#Last reboot: $last_reboot
	#Logical_Volume_Manager_Used: $lvmu
	#Connexions TCP: $ctcp ESTABLISHED
	#User log: $ulog
	#Network: INTERNET_PROTOCOL $ip ($mac)
	#Sudo: $cmds cmd"
