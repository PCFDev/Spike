#!/bin/sh

yum -y install wget

yum -y install zip

yum -y install unzip

yum clean all

echo "[sqlserver/install_prereqs.sh] NOTE: Shrine saves only query history, not patient data"
echo "[sqlserver/install-prereqs.sh] installing to a MSSQL database for SHRINE. Any SQL database can be used."

#yum -y install mysql-server
#yum clean all
#service mysqld start

#########
echo "[sqlserver/install-prereqs.sh] begin MSSQL tools."
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
echo "[sqlserver/install-prereqs.sh] MSSQL tools done."
#########
