. .\functions.ps1
. .\common.ps1

$ShrineWar = "shrine-war-$_SHRINE_VERSION.war"
$ShrineWarURL = "$_NEXUS_URL_BASE/shrine-war/$_SHRINE_VERSION/$ShrineWar"

$ShrineProxy = "shrine-proxy-$_SHRINE_VERSION.war"
$ShrineProxyURL = "$_NEXUS_URL_BASE/shrine-proxy/$_SHRINE_VERSION/$ShrineProxy"

#Make Temporary Shrine Setup Directory
mkdir C:\opt\shrine\setup
$_SHRINE_SETUP = "$_SHRINE_HOME\setup"

echo "downloading shrine and shrine-proxy war files"
#Download shrine.war and shrine-proxy.war to tomcat
Invoke-WebRequest $ShrineWarURL  -OutFile $_SHRINE_SETUP\shrine.war
Invoke-WebRequest $ShrineProxyURL  -OutFile $_SHRINE_SETUP\shrine-proxy.war

echo "downloading shrine-webclient to tomcat"
#Download Subversion, run to copy shrine-webclient to webapps folder in tomcat
Invoke-WebRequest http://downloads.sourceforge.net/project/win32svn/1.8.11/apache22/svn-win32-1.8.11.zip?  -OutFile $_SHRINE_SETUP\subversion.zip -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer
#mkdir $_SHRINE_SETUP\svn
unzip $_SHRINE_SETUP\subversion.zip $_SHRINE_SETUP\svn
& "$_SHRINE_SETUP\svn\svn-win32-1.8.11\bin\svn.exe" checkout $_SHRINE_SVN_URL_BASE/code/shrine-webclient/  $_SHRINE_SETUP\shrine-webclient


$ShrineAdapterMappingsURL = "$_SHRINE_SVN_URL_BASE/ontology/SHRINE_Demo_Downloads/AdapterMappings_i2b2_DemoData.xml"

echo "downloading AdapterMappings.xml file to tomcat"
Invoke-WebRequest $ShrineAdapterMappingsURL  -OutFile $_SHRINE_SETUP\AdapterMappings.xml

#Replace contents of tomcat_server_8.xml with common settings
interpolate_file .\tomcat_server_8.xml "SHRINE_PORT" $_SHRINE_PORT |
    interpolate "SHRINE_SSL_PORT" $_SHRINE_SSL_PORT | 
    interpolate "KEYSTORE_FILE" "$_SHRINE_HOME\shrine.keystore" |
    interpolate "KEYSTORE_PASSWORD" "changeit" > $_SHRINE_SETUP\server.xml


#Remove Shrine Setup Directory
