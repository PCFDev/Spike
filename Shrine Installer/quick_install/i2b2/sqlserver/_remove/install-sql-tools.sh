#!/bin/bash

#########
echo "[i2b2/install-sql-tools.sh] begin."
#########
#Handles installing the tools need to connect to MSSQL server and run scripts
#########

yum -y install unixODBC
yum -y install unixODBC-devel
yum -y install glibc-utils.i686

wget http://dl.fedoraproject.org/pub/epel/6/i386/freetds-0.91-2.el6.i686.rpm
wget http://dl.fedoraproject.org/pub/epel/6/i386/freetds-devel-0.91-2.el6.i686.rpm

rpm -i freetds-0.91-2.el6.i686.rpm
rpm -i freetds-devel-0.91-2.el6.i686.rpm

#########
echo "[i2b2/install-sql-tools.sh] done."
#########
