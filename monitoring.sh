ARCH=$(uname -a)
#uname : to check the system information of your Linux computer | -a : all_information.
PCPU=$(grep "physical id" /proc/cpuinfo | wc -l)
#wc -l : prints the number of lines in a file.
VCPU=$(grep  processor /proc/cpuinfo | wc -l)

RAM_TOTA=$(free -h | grep Mem | awk '{print $2}')
RAM_USED=$(free -h | grep Mem | awk '{print $3}')
RAM_PERC=$(free -h | grep Mem | awk '{printf("%.2f",$3 / $2 * 100)}')
#free : to get a detailed report on the system’s memory usage.
#-h : to view the information in human-readable format (Kb, Mb and Gb).
DISK_USAGE=$(df --total -h | grep total | awk '{printf("%s/%s (%d%%)", $3, $2, $5)}')
#df : displays the amount of disk space available on the filesystem with each file name's argument | --total : to get the total.
CPU_LOAD=$(top -bn1 | grep %Cpu | awk '{printf("%.1f%%"), $2 + $4}')
# top: to show the Linux processes.
#-b : for sending output from 'top' to other program or to a file and -n to spicefie the max number of iteration.
LAST_BOOT=$(who -b | awk '{printf "%s  %s" ,$3,$4}')
#who : to display the users currently logged in to your UNIX or Linux operating system | -b : to get the date of the last system boot.
LVM_USE=$(lsblk | grep lvm | wc -l | awk '{if($1) {print "yes"}else {print "no"}}')
#lsblk : to show lists information about all available or the specified block devices.
CON_TCP=$(ss -ta | grep ESTAB | wc -l)
#ss : to dump socket statistics | -a -t : display all TCP sockets.
USR_LOG=$(grep TCP /proc/net/sockstat | awk '{print $3}')
IP_ADD=$(hostname -I | awk '{print $1}')
#hostname : to show the name of the device | -I to show its address.
MAC_ADD=$(ip link show | grep link/ether | awk '{print $2}')
#ip : to show or manipulate routing | link : to display and modify network interfaces | show : to see link-layer information of all available devices.
SUDO=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)
#journalctl : to view systemd and kernel and journal logs.
wall "
	Architecture	: $ARCH
	Physical CPUs	: $PCPU
	Virtual CPUs	: $VCPU
	Memory Usage	: $RAM_USED/$RAM_TOTA	 ($RAM_PERC%)
	Disk Usage      : $DISK_USAGE
	Cpu load	: $CPU_LOAD
	Last boot	: $LAST_BOOT
	Lvm use		: $LVM_USE
	Connections TCP	: $CON_TCP  ESTABLISHED
	User log	: $USR_LOG
	Network		: IP $IP_ADD ($MAC_ADD)
	Sudo		: $SUDO cmd"
