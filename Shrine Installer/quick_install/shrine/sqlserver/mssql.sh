#!/bin/bash

echo "[shrine/mssql.sh] Begin."

#########
# SHRINE MSSQL setup for Query History Database.
#
# SHRINE uses hibernate, so technically any DB vendor will suffice.
# We default to mysql since it is so easy to setup.
#
#########
source ./shrine.rc

mkdir -p $SHRINE_HOME
mkdir -p work; cd work
#########

echo "[shrine/mssql.sh] creating shrine database" $SHRINE_DB_NAME;

interpolate_file ../mssql.sql "SHRINE_DB_NAME" "$SHRINE_DB_NAME" | \
interpolate "SHRINE_DB_USER" "$SHRINE_DB_USER" | \
interpolate "SHRINE_DB_PASSWORD" "$SHRINE_DB_PASSWORD" | \
interpolate "SHRINE_DB_SCHEMA" "$SHRINE_DB_SCHEMA" > mssql.sql.interpolated

#mysql -u root < mysql.sql.interpolated
./exec_sql.py -i mssql.sql.interpolated -s $SHRINE_DB_HOST -u $SHRINE_DB_ADMIN_USER -p $SHRINE_DB_ADMIN_PASSWORD -d 'master'

#wget ${SHRINE_SVN_URL_BASE}/code/adapter/src/main/resources/adapter.sql
#mysql -u $SHRINE_MYSQL_USER -p$SHRINE_MYSQL_PASSWORD -D shrine_query_history < adapter.sql
./exec_sql.py -i adapter.sql -s $SHRINE_DB_HOST -u $SHRINE_DB_USER -p $SHRINE_DB_PASSWORD -d $SHRINE_DB_NAME

#wget ${SHRINE_SVN_URL_BASE}/code/broadcaster-aggregator/src/main/resources/hub.sql
#mysql -u $SHRINE_MYSQL_USER -p$SHRINE_MYSQL_PASSWORD -D shrine_query_history < hub.sql
./exec_sql.py -i hub.sql -s $SHRINE_DB_HOST -u $SHRINE_DB_USER -p $SHRINE_DB_PASSWORD -d $SHRINE_DB_NAME

#wget ${SHRINE_SVN_URL_BASE}/code/service/src/main/resources/create_broadcaster_audit_table.sql
#mysql -u $SHRINE_MYSQL_USER -p$SHRINE_MYSQL_PASSWORD -D shrine_query_history < create_broadcaster_audit_table.sql
./exec_sql.py -i create_broadcaster_audit_table.sql -s $SHRINE_DB_HOST -u $SHRINE_DB_USER -p $SHRINE_DB_PASSWORD -d $SHRINE_DB_NAME


echo "[shrine/mssql.sh] Done."

cd ..
