arch="$(uname -a)"
cpus="$(lscpu -p | tail -1 | awk -F ',' '{ print $2 + 1 }')"
vcpus="$(lscpu -p | tail -1 | awk -F ',' '{ print $2 + 1 }')"
ram="$(free -m | grep Mem | awk '{ printf "%s/%sMB (%.2f%%)", $3, $2, ($3 / $2 * 100.0) }')"
disk="$(df -m --total | grep 'total' | awk '{ printf "%.1f/%.1fGB (%.1f%%)\n", ($3/1024), ($2/1024), $5 }')"
load="$(top -bn1 | head -1 | awk '{ printf "%.1f%%\n", $(NF) }')"
reboot="$(last reboot --fulltime | head -1 | awk '{ printf "%s %s %s %s\n", $6, $7, $9, $8 }')"
lvm="$(lsblk | grep 'lvm' | wc -l | awk '{ if ($1) print "Yes"; else print "No" }')"
conns="$(ss -tH state established | wc -l)"
users="$(users | sed 's. .\n.' | uniq | wc -l)"
network="IP $(hostname -I)($(ip address | grep 'ether' | awk '{ printf $2 }'))"
sudo="$(journalctl _COMM=sudo -q --no-pager | grep 'COMMAND' | wc -l) cmd"

wall "\
Architecture: $arch
CPU(s): $cpus
vCPU(s): $vcpus
RAM: $ram
Disk memory: $disk
CPU load: $load
Last reboot: $reboot
LVM usage: $lvm
TCP connections: $conns
Current users: $users
Network: $network
Sudo commands: $sudo\
"
