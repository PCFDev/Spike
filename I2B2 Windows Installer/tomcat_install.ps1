﻿<#
.SYNOPSIS
Install tomcat on Windows Server


.DESCRIPTION
This script will download the correctversion of Apache Tomcat 8.0. It will then unzip to 
another directory and copy the contents into the shrine\tomcat directory beneath the 
user-specified or default directory. It will also install Tomcat 8.0 as a service running 
automatically.

.PARAMETER $tomcat_path
Define a path for tomcat to be extracted to. Avoid directory locations that include spaces
within their paths.

.PARAMETER $InstallService
Tomcat is installed as a Windows service by default. Using the -s alias and $false will 
keep Tomcat from being installed as a service.

.EXAMPLE
.\tomcat_install -s $false
Skips the installation of Tomcat as a Windows service.

.EXAMPLE
.\tomcat_install C:\newDirectory
tomcat_install will extract Tomcat to the C:\newDirectory\shrine\tomcat directory and
install Tomcat as a service.

.EXAMPLE
.\tomcat_install C:\otherDirectory -s $false
tomcat_install will extract Tomcat to the C:\otherDirectory\shrine\tomcat directory and
does not install Tomcat as a service.

.EXAMPLE
PowerShell will number them for you when it displays your help text to a user.
#>


[CmdletBinding()]
Param(
    [parameter(Mandatory=$false)]
	[AllowEmptyString()]
	[string]$tomcat_path,

    [parameter(Mandatory=$false)]
	[alias("s")]
	[bool]$InstallService=$true
)

#Include functions.ps1 for unzip functionality
#Include configurations.ps1 for file download url
. .\functions.ps1
. .\configuration.ps1


#If given no argument for install directory, set default directory C:\opt
if($tomcat_path -eq "")
{
    $tomcat_path="C:\opt"
}

#Using a process level Environment Variable simplifies the multiple calls
#to the install directory
$Env:TOMCAT = $tomcat_path

#Create temp downloads folder
if(!(Test-Path $Env:TOMCAT\shrine\downloads)){
    mkdir $Env:TOMCAT\shrine\downloads
}

#Download tomcat archive, unzip to temp directory, copy contents to shrine\tomcat folder
#and remove the downloads and temp folders
if(Test-Path $Env:TOMCAT\shrine\downloads\tomcat.zip){
    Remove-Item $Env:TOMCAT\shrine\downloads\tomcat.zip
}
Invoke-WebRequest $__tomcatDownloadUrl -OutFile $Env:TOMCAT\shrine\downloads\tomcat8.zip
unzip $Env:TOMCAT\shrine\downloads\tomcat8.zip $Env:TOMCAT\shrine
if(Test-Path $Env:TOMCAT\shrine\tomcat){
    Remove-Item $Env:TOMCAT\shrine\tomcat -Recurse
    mkdir $Env:TOMCAT\shrine\tomcat
}
Copy-Item $Env:TOMCAT\shrine\apache-tomcat-8.0.21\* -Destination $Env:TOMCAT\shrine\tomcat -Container -Recurse
Remove-Item $Env:TOMCAT\shrine\downloads -Recurse
Remove-Item $Env:TOMCAT\shrine\apache-tomcat-8.0.21 -Recurse

#This environment variable is required for Tomcat to run and to install as a service
[Environment]::SetEnvironmentVariable("CATALINA_HOME","$Env:TOMCAT\shrine\tomcat","Machine")

#If $InstallService is $true (as default), this will install the Tomcat Windows Service.
#It will set the service to Automatic startup, rename it to Apache Tomcat 8.0 and start it.
if($InstallService -eq $true)
{
    #Must set a process level environment variable for Powershell to use during this instance
    $env:CATALINA_HOME = "$Env:TOMCAT\shrine\tomcat"

    $env:JAVA_HOME = "C:\Program Files\Java\jdk1.7.0_75"

    & "$Env:CATALINA_HOME\bin\service.bat" install
    
    #& "$Env:CATALINA_HOME\bin\tomcat8.exe" //US//Tomcat8 --DisplayName="Apache Tomcat 8.0"

    Set-Service Tomcat8 -StartupType Automatic

    Start-Service Tomcat8   
}