#!/bin/bash

freeMem=`mysql --defaults-file=/root/.my.cnf -s -e "SHOW STATUS WHERE Variable_name='Qcache_free_memory'" | awk '{print $2}'`;
totalMem=`mysql --defaults-file=/root/.my.cnf -s -e "SHOW VARIABLES WHERE Variable_name ='query_cache_size'" | awk '{print $2}'`;
usedMem=$((totalMem-freeMem));

freePct=$(echo "scale=4;($freeMem/$totalMem) * 100" | bc);
freePct=`echo $freePct | awk '{ printf "%.0f\n", $1 }'`;

usedPct=$(echo "scale=4;($usedMem/$totalMem) * 100" | bc);
usedPct=`echo $usedPct | awk '{ printf "%.0f\n", $1 }'`;

freeMB=$(echo "scale=4;$freeMem/1048576" | bc);
freeMB=`echo $freeMB | awk '{ printf "%.1f\n", $1 }'`;

totalMB=$(echo "scale=4;$totalMem/1048576" | bc);
totalMB=`echo $totalMB | awk '{ printf "%.1f\n", $1 }'`;

usedMB=$(echo "scale=4;$usedMem/1048576" | bc);
usedMB=`echo $usedMB | awk '{ printf "%.1f\n", $1 }'`;

echo -e "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
printf "%-28s%7s%7s\n" "MySQL Query Cache - Used:" "`echo $usedMB;`M" "$usedPct%";
printf "%-28s%7s%7s\n" "MySQL Query Cache - Free:" "`echo $freeMB;`M" "$freePct%";
printf "%-28s%7s%7s\n" "MySQL Query Cache - Total:" "`echo $totalMB;`M" ""; 
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";

processesInUse=`ps -eo command,pcpu,pmem,rss | grep apache2 | grep -v "\(root\|grep\) " | awk '{print $4;}' | while read -r; do if [ $REPLY != '0.0' ]; then 
echo "val"; fi done | xargs -d"\n" | wc -w`;
systemMem=`free -m | awk '{print $2}' | awk '{print $1}' | xargs -d"\n" | awk '{print $2}'`;
ps -eo command,pcpu,pmem,rss | grep apache2 | grep -v "\(root\|grep\) " | awk '{print $6;}' | awk -v sysMem=${systemMem} -v psUse=${processesInUse} '{count = count + 1}{total = total + $1}END{printf "%-28s%7s\n%-28s%7s\n%-28s%6.0f%1s%6.1f%1s\n%-28s%6.1f%1s\n", "Active Apache Processes:", psUse, "Total Apache Processes:", (count-1), "Apache Memory Usage:", (total/1024), "M", (((total/1024)/sysMem) * 100), "%", "Apache Avg. Process Size:", ((total/1024)/count), "M"}';
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n";
