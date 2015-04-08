#!/usr/bin/python

import sys, getopt, _mssql

def main(argv):
   inputfile = ''
   server = ''
   username = ''
   password = ''
   database = ''

   try:

      opts, args = getopt.getopt(argv,"hi:s:u:p:d",["ifile=", "server=", "username=", "password=", "database="])

   except getopt.GetoptError:
      print 'exec_sql.py -i <inputfile>'
      sys.exit(2)

   for opt, arg in opts:

      if opt == '-h':
         print 'exec_sql.py -i <inputfile> -s <server> -u <username> -p <password> -d <database>'
         sys.exit()

      elif opt in ("-i", "--ifile"):
         inputfile = arg

      elif opt in ("-s", "--server"):
         server = arg

      elif opt in ("-u", "--username"):
         username = arg

      elif opt in ("-p", "--password"):
         password = arg

      elif opt in ("-d", "--database"):
         database = arg


   print 'Executing file: ', inputfile
   print 'Executing on server: ', server

   fo  = open(inputfile)
   sql = fo.read()
   print sql

   conn = _mssql.connect(server=server, user=username, password=password, database=database)
   conn.execute_non_query(sql)


if __name__ == "__main__":
   main(sys.argv[1:])
