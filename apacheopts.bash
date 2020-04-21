#!/bin/bash
###Adding Apache Optimizations from command line###
#
#Test to see if CentOS
if [ -e /etc/redhat-release ]; then
#Test to see if cPanel
  if [ -e /var/cpanel/conf/apache ]; then
#View current opts

	echo "Current Apache Optimizations:"
	
	egrep '(^StartServers|^MinSpare|^MaxSpare|^MaxCli|^ServerLim|^MaxReqests|^KeepAlive|^Timeout)' /usr/local/apache/conf/httpd.conf || echo "No Optimizations Currently Set"
	echo

#Ask user to enter desired optimizations

	echo "Let's update the Apache Optimizations"
	echo
	echo -n StartServers:
	read var_ss
	echo $var_ss
	echo -n MinSpareServers:
	read var_minss
	echo $var_minss
	echo -n MaxSpareServers:
	read var_maxss
	echo $var_maxss	
	echo -n MaxClients:
	read var_mc
	echo $var_mc
	echo -n ServerLimit:
	read var_sl
	echo $var_sl
	echo -n MaxRequestsPerChild:
	read var_mrpc	
	echo $var_mrpc
	echo -n KeepAlive On/Off:
	read var_ka
	echo $var_ka
	echo -n KeepAliveTimeout:
	read var_kat
	echo $var_kat
	echo -n MaxKeepAliveRequests:
	read var_mkar
	echo $var_mkar
	echo -n Timeout:
	read var_t
	echo $var_t

#Test to see if /var/cpanel/conf/apache/local file exists

	if [ -e /var/cpanel/conf/apache/local ]; then
	
#set httploc to be /var/cpanel/conf/apache/local

		httploc=/var/cpanel/conf/apache/local

#If it does, copy existing file to .lwbak to be safe

		cp /var/cpanel/conf/apache/local{,.bak}

#sed in the entered variables

        sed -i 's/\"timeout\"\: [0-9].*/\"timeout\"\: '$var_t'/' $httploc
        sed -i 's/\"startservers\"\: [0-9].*/\"startservers\"\: '$var_ss'/' $httploc
        sed -i 's/\"maxclients\"\: [0-9].*/\"maxclients\"\: '$var_mc'/' $httploc
        sed -i 's/\"minspareservers\"\: [0-9].*/\"minspareservers\"\: '$var_minss'/' $httploc
        sed -i 's/\"maxspareservers\"\: [0-9].*/\"maxspareservers\"\: '$var_maxss'/' $httploc
        sed -i 's/\"serverlimit\"\: [0-9].*/\"serverlimit\"\: '$var_sl'/' $httploc
        sed -i 's/\"maxrequestsperchild\"\: [0-9].*/\"maxrequestsperchild\"\: '$var_mrpc'/' $httploc
        sed -i 's/\"keepalive\"\:\ .[A-Za-z].*/\"keepalive\"\:\ '\'$var_ka\''/g' $httploc
        sed -i 's/\"keepalivetimeout\"\: [0-9].*/\"keepalivetimeout\"\: '$var_kat'/' $httploc
        sed -i 's/\"maxkeepaliverequests\"\: [0-9].*/\"maxkeepaliverequests\"\: '$var_mkar'/' $httploc

#rebuild httpd.conf and restart apache

	/scripts/rebuildhttpdconf
	/etc/init.d/httpd restart

#If /var/cpanel/conf/apache/local does not exist, create it	

	else
		touch /var/cpanel/conf/apache/local

#set httploc to be /var/cpanel/conf/apache/local

		httploc=/var/cpanel/conf/apache/local

#Add default 1gb opts to /var/cpanel/conf/apache/local

		cat > /var/cpanel/conf/apache/local <<EOF  
---
"main":
  "keepalive":
    "item":
      "keepalive": 'On'
  "keepalivetimeout":
    "item":
      "keepalivetimeout": 2
  "maxclients":
    "item":
      "maxclients": 40
  "maxkeepaliverequests":
    "item":
      "maxkeepaliverequests": 100
  "maxrequestsperchild":
    "item":
      "maxrequestsperchild": 400
  "maxspareservers":
    "item":
      "maxspareservers": 10
  "minspareservers":
    "item":
      "minspareservers": 5
  "serverlimit":
    "item":
      "serverlimit": 40
  "startservers":
    "item":
      "startservers": 10
  "timeout":
    "item":
      "timeout": 50
EOF

#Now, sed in the variables entered earlier by the user

        sed -i 's/\"timeout\"\: [0-9].*/\"timeout\"\: '$var_t'/' $httploc
        sed -i 's/\"startservers\"\: [0-9].*/\"startservers\"\: '$var_ss'/' $httploc
        sed -i 's/\"maxclients\"\: [0-9].*/\"maxclients\"\: '$var_mc'/' $httploc
        sed -i 's/\"minspareservers\"\: [0-9].*/\"minspareservers\"\: '$var_minss'/' $httploc
        sed -i 's/\"maxspareservers\"\: [0-9].*/\"maxspareservers\"\: '$var_maxss'/' $httploc
        sed -i 's/\"serverlimit\"\: [0-9].*/\"serverlimit\"\: '$var_sl'/' $httploc
        sed -i 's/\"maxrequestsperchild\"\: [0-9].*/\"maxrequestsperchild\"\: '$var_mrpc'/' $httploc
        sed -i 's/\"keepalive\"\:\ .[A-Za-z].*/\"keepalive\"\:\ '\'$var_ka\''/g' $httploc
        sed -i 's/\"keepalivetimeout\"\: [0-9].*/\"keepalivetimeout\"\: '$var_kat'/' $httploc
        sed -i 's/\"maxkeepaliverequests\"\: [0-9].*/\"maxkeepaliverequests\"\: '$var_mkar'/' $httploc

#Rebuild httpdconf and restart apache
	/scripts/rebuildhttpdconf
	/etc/init.d/httpd restart
    
	fi
#If CentOS and Not cPanel, add opts to /etc/httpd/conf/httpd.conf
  elif [ -e /etc/httpd/conf/httpd.conf ]; then

#set httploc to equal /etc/httpd/conf/httpd.conf
	
	httploc=/etc/httpd/conf/httpd.conf

#View current opts

	echo "Current Apache Optimizations:"
	
    echo KeepAlive=`awk '/^[Kk]eep[Aa]live\ / {print $2}' $httploc`
    echo MaxKeepAliveRequests=`awk '/^[Mm]ax[Kk]eep[Aa]live[Rr]equests/ {print $2}' $httploc`
    echo KeepAliveTimeout=`awk '/^[Kk]eep[Aa]live[Tt]imeout/ {print $2}' $httploc`
    echo MinSpareServers=`awk '/^[Mm]in[Ss]pare[Ss]ervers/ {print $2}' $httploc`
    echo MaxSpareServers=`awk '/^[Mm]ax[Ss]pare[Ss]ervers/ {print $2}' $httploc`
    echo Timeout=`awk '/^[Tt]imeout/ {print $2}' $httploc`
    echo ServerLimit=`awk '/^[Ss]erver[Ll]imit/ {print $2}' $httploc`
    echo StartServers=`awk '/^[Ss]tart[Ss]ervers/ {print $2}' $httploc`
    echo MaxClients=`awk '/^[Mm]ax[Cc]lients/ {print $2}' $httploc`
    echo MaxRequestsPerChild=`awk '/^[Mm]ax[Rr]equests[Pp]er[Cc]hild/ {print $2}' $httploc`
	
	echo

#Ask user to enter desired optimizations
	echo "WARNING - this will overwrite Optimizations for both MPMs"
	echo "Let's update the Apache Optimizations"
	echo
	echo -n StartServers:
	read var_ss
	echo $var_ss
	echo -n MinSpareServers:
	read var_minss
	echo $var_minss
	echo -n MaxSpareServers:
	read var_maxss
	echo $var_maxss	
	echo -n MaxClients:
	read var_mc
	echo $var_mc
	echo -n ServerLimit:
	read var_sl
	echo $var_sl
	echo -n MaxRequestsPerChild:
	read var_mrpc	
	echo $var_mrpc
	echo -n KeepAlive On/Off:
	read var_ka
	echo $var_ka
	echo -n KeepAliveTimeout:
	read var_kat
	echo $var_kat
	echo -n MaxKeepAliveRequests:
	read var_mkar
	echo $var_mkar
	echo -n Timeout:
	read var_t
	echo $var_t
  
#Copy httpd.conf to .$time.bak

    cp /etc/httpd/conf/httpd.conf{,.bak}
  	
#Now, sed in the opts entered earlier

    sed -i 's/^[Tt]imeout[[:space:]]\+[0-9].*/Timeout\ '$var_t'/g' $httploc
    sed -i 's/^[Ss]tart[Ss]ervers[[:space:]]\+[0-9].*/StartServers\ '$var_ss'/g' $httploc
    sed -i 's/^[Mm]ax[Cc]lients[[:space:]]\+[0-9].*/MaxClients\ '$var_mc'/g' $httploc
    sed -i 's/^[Mm]in[Ss]pare[Ss]ervers[[:space:]]\+[0-9].*/MinSpareServers\ '$var_minss'/g' $httploc
    sed -i 's/^[Mm]ax[Ss]pare[Ss]ervers[[:space:]]\+[0-9].*/MaxSpareServers\ '$var_maxss'/g' $httploc
    sed -i 's/^[Ss]erver[Ll]imit[[:space:]]\+[0-9].*/ServerLimit\ '$var_sl'/g' $httploc
    sed -i 's/^[Mm]ax[Rr]equests[Pp]er[Cc]hild[[:space:]]\+[0-9].*/MaxRequestsPerChild\ '$var_mrpc'/g' $httploc
    sed -i 's/^[Kk]eep[Aa]live[[:space:]]\+[A-Za-z].*/KeepAlive\ '$var_ka'/g' $httploc
    sed -i 's/^[Kk]eep[Aa]live[Tt]imeout[[:space:]]\+[0-9].*/KeepAliveTimeout\ '$var_kat'/g' $httploc
    sed -i 's/^[Mm]ax[Kk]eep[Aa]live[Rr]equests[[:space:]]\+[0-9].*/MaxKeepAliveRequests\ '$var_mkar'/g' $httploc

    
  /etc/init.d/httpd restart

  fi
  
elif [ -e /etc/debian_version ]; then

#set httploc variable

  httploc=/etc/apache2/httpd.conf

#Backup httpconf
  cp $httploc{,.bak}

#Show Current Opts

	echo "Current Apache Optimizations:"

    echo KeepAlive=`awk '/[Kk]eep[Aa]live\ / {print $2}' $httploc`
    echo MaxKeepAliveRequests=`awk '/[Mm]ax[Kk]eep[Aa]live[Rr]equests/ {print $2}' $httploc`
    echo KeepAliveTimeout=`awk '/[Kk]eep[Aa]live[Tt]imeout/ {print $2}' $httploc`
    echo MinSpareServers=`awk '/[Mm]in[Ss]pare[Ss]ervers/ {print $2}' $httploc`
    echo MaxSpareServers=`awk '/[Mm]ax[Ss]pare[Ss]ervers/ {print $2}' $httploc`
    echo Timeout=`awk '/[Tt]imeout/ {print $2}' $httploc`
    echo ServerLimit=`awk '/[Ss]erver[Ll]imit/ {print $2}' $httploc`
    echo StartServers=`awk '/[Ss]tart[Ss]ervers/ {print $2}' $httploc`
    echo MaxClients=`awk '/[Mm]ax[Cc]lients/ {print $2}' $httploc`
    echo MaxRequestsPerChild=`awk '/[Mm]ax[Rr]equests[Pp]er[Cc]hild/ {print $2}' $httploc`	
	

	echo
  
#Ask user to enter desired optimizations
	echo "WARNING - this will overwrite Optimizations for both MPMs"
	echo "Let's update the Apache Optimizations"
	echo
	echo -n StartServers:
	read var_ss
	echo $var_ss
	echo -n MinSpareServers:
	read var_minss
	echo $var_minss
	echo -n MaxSpareServers:
	read var_maxss
	echo $var_maxss	
	echo -n MaxClients:
	read var_mc
	echo $var_mc
	echo -n ServerLimit:
	read var_sl
	echo $var_sl
	echo -n MaxRequestsPerChild:
	read var_mrpc	
	echo $var_mrpc
	echo -n KeepAlive On/Off:
	read var_ka
	echo $var_ka
	echo -n KeepAliveTimeout:
	read var_kat
	echo $var_kat
	echo -n MaxKeepAliveRequests:
	read var_mkar
	echo $var_mkar
	echo -n Timeout:
	read var_t
	echo $var_t

#If the conf has content

  if [[ -s /etc/apache2/httpd.conf ]]; then

#Substitute in Opts entered earlier.

    perl -i -p -e 's/^((\s+)?)[Tt]imeout\s+[0-9].*/Timeout\ '$var_t'/g' $httploc
    perl -i -p -e 's/^((\s+)?)[Ss]tart[Ss]ervers\s+[0-9].*/StartServers\ '$var_ss'/g' $httploc
    perl -i -p -e 's/^((\s+)?)[Mm]ax[Cc]lients\s+[0-9].*/MaxClients\ '$var_mc'/g' $httploc
    perl -i -p -e 's/^((\s+)?)[Mm]in[Ss]pare[Ss]ervers\s+[0-9].*/MinSpareServers\ '$var_minss'/g' $httploc
    perl -i -p -e 's/^((\s+)?)[Mm]ax[Ss]pare[Ss]ervers\s+[0-9].*/MaxSpareServers\ '$var_maxss'/g' $httploc
    perl -i -p -e 's/^((\s+)?)[Ss]erver[Ll]imit\s+[0-9].*/ServerLimit\ '$var_sl'/g' $httploc
    perl -i -p -e 's/^((\s+)?)[Mm]ax[Rr]equests[Pp]er[Cc]hild\s+[0-9].*/MaxRequestsPerChild\ '$var_mrpc'/g' $httploc
    perl -i -p -e 's/^((\s+)?)[Kk]eep[Aa]live\s+[A-Za-z].*/KeepAlive\ '$var_ka'/g' $httploc
    perl -i -p -e 's/^((s\+)?)[Kk]eep[Aa]live[Tt]imeout\s+[0-9].*/KeepAliveTimeout\ '$var_kat'/g' $httploc
    perl -i -p -e 's/^((s\+)?)[Mm]ax[Kk]eep[Aa]live[Rr]equests\s+[0-9].*/MaxKeepAliveRequests\ '$var_mkar'/g' $httploc

#Else, if file empty, put in 1gb default opts, then sed in changes

  else

		cat > $httploc <<EOF 
KeepAlive On
MaxKeepAliveRequests 100
KeepAliveTimeout 2
<IfModule prefork.c>
	StartServers 5
	ServerLimit 50
	MinSpareServers 5
	MaxSpareServers 10
	MaxClients 50
	MaxRequestsPerChild 400
</IfModule>
<IfModule worker.c>
	ServerLimit 2
	StartServers 1
	MinSpareThreads 25
	MaxSpareThreads 50
	ThreadsPerChild 25
	MaxClients 50
	MaxRequestsPerChild 400
</IfModule>
Timeout 50
EOF

#Substitute in Opts entered earlier.
    perl -i -p -e 's/^((\s+)?)[Tt]imeout\s+[0-9].*/Timeout\ '$var_t'/g' $httploc
    perl -i -p -e 's/^((\s+)?)[Ss]tart[Ss]ervers\s+[0-9].*/StartServers\ '$var_ss'/g' $httploc
    perl -i -p -e 's/^((\s+)?)[Mm]ax[Cc]lients\s+[0-9].*/MaxClients\ '$var_mc'/g' $httploc
    perl -i -p -e 's/^((\s+)?)[Mm]in[Ss]pare[Ss]ervers\s+[0-9].*/MinSpareServers\ '$var_minss'/g' $httploc
    perl -i -p -e 's/^((\s+)?)[Mm]ax[Ss]pare[Ss]ervers\s+[0-9].*/MaxSpareServers\ '$var_maxss'/g' $httploc
    perl -i -p -e 's/^((\s+)?)[Ss]erver[Ll]imit\s+[0-9].*/ServerLimit\ '$var_sl'/g' $httploc
    perl -i -p -e 's/^((\s+)?)[Mm]ax[Rr]equests[Pp]er[Cc]hild\s+[0-9].*/MaxRequestsPerChild\ '$var_mrpc'/g' $httploc
    perl -i -p -e 's/^((\s+)?)[Kk]eep[Aa]live\s+[A-Za-z].*/KeepAlive\ '$var_ka'/g' $httploc
    perl -i -p -e 's/^((s\+)?)[Kk]eep[Aa]live[Tt]imeout\s+[0-9].*/KeepAliveTimeout\ '$var_kat'/g' $httploc
    perl -i -p -e 's/^((s\+)?)[Mm]ax[Kk]eep[Aa]live[Rr]equests\s+[0-9].*/MaxKeepAliveRequests\ '$var_mkar'/g' $httploc

  fi
#restart apache2

  service apache2 restart

#If not CentOS or Debian based, fail

else
	echo "At this time, this script only works on RedHat and Debian based servers"
fi
