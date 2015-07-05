---
title: pt-kill CentOS init.d script
author: bramp
layout: post
date: 2012-09-30
categories:
  - Blog
tags:
  - init.d
  - Linux
  - mysql
aliases:
  - /blog/2012/09/30/pt-kill-centos-init-d-script/
---
[pt-kill][1] is a neat little application that can stop long running MySQL queries. It was formally know as [mk-kill][2] before [Percona][3] took over the project. Here is the init.d script I use (as one doesn&#8217;t seem provided by the project): <!--more-->

```bash
#!/bin/sh
#
# pt-kill	This shell script takes care of starting and stopping
#               the pt-kill services.
#
# chkconfig: - 60 20
# description: pt-kill stops long running MySQL queries
#
# probe: true

# Source function library.
. /etc/rc.d/init.d/functions

RETVAL=0

# See how we were called.
case "$1" in
  start)
    echo -n $"Starting pt-kill: "
 
    pt-kill \
      --pid /var/run/pt-kill.pid \
      --daemonize \
      --interval 5 \
      --busy-time 60 \
      --wait-after-kill 15  \
      --ignore-info '(?i-smx:^insert|^update|^delete|^load)' \
      --match-info '(?i-xsm:select)' \
      --ignore-user '(?i-xsm:root)' \
      --log /var/log/mysql-kill.log \
      --print \
      --execute-command '(echo "Subject: pt-kill query found on `hostname`"; tail -1 /var/log/mysql-kill.log)|/usr/sbin/sendmail -t you@example.com' \
      --kill-query
 
    RETVAL=$?
    echo
    [ $RETVAL -ne 0 ] &#038;&#038; exit $RETVAL
 
  ;;
  stop)
        # Stop daemons.
       	echo -n $"Shutting down pt-kill: "
        killproc pt-kill
        echo
	;;
  restart)
	$0 stop
        $0 start
        ;;
  *)
    	echo $"Usage: pt-kill {start|stop}"
        RETVAL=3
        ;;
esac
 
exit $RETVAL
```

**Usage:**

Create the script as /etc/init.d/pt-kill, and change the pt-kill command in the middle of the script to suit your needs. Then run &#8216;chkconfig &#8211;level 345 pt-kill on&#8217; to ensure this script starts up at boot. Alternatively test the script with &#8216;/etc/init.d/pt-kill start&#8217; or &#8216;/etc/init.d/pt-kill stop&#8217;.

Thanks to [MySQL Diary][4] as they provided their default pt-kill command line. Perhaps in future someone could create a more generic startup script.

 [1]: http://www.percona.com/doc/percona-toolkit/2.1/pt-kill.html
 [2]: http://www.maatkit.org/doc/mk-kill.html
 [3]: http://www.Percona.com
 [4]: http://www.mysqldiary.com/you-must-have-a-killer-in-your-system/
 
