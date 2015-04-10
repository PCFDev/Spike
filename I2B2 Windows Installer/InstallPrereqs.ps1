Add-Type -AssemblyName System.IO.Compression.FileSystem

$__jbossDownloadUrl = "http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip"
$__jbossServiceDownloadUrl = "http://www.jboss.org/jbossweb/downloads/jboss-native-2-0-10/"

if($global:windows_arch -eq "x64"){

}


$__antFolderName = "apache-ant-1.9.4"
$__antDownloadUrl = "http://mirror.tcpdiag.net/apache//ant/binaries/" + $__antFolderName + "-bin.zip"

$__javaDownloadUrl = ""

if($global:windows_arch -eq "x64"){
	$__javaDownloadUrl = "http://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-windows-x64.exe"
} else {
    #NOTE: test this url, if it works we can break out the filename and folder..?
	$__javaDownloadUrl = "https://download.oracle.com/otn-pub/java/jdk/7u75-b13/jdk-7u75-windows-i586.exe"
}

$__axisDownloadUrl = "https://www.i2b2.org/software/projects/installer/axis2-1.6.2-war.zip"

$out = &"java.exe" -version 2>&1
$javaver = $out[0].tostring();
$javaInstalled = $true
#NOTE: need to truly set if java is installed

if($javaInstalled -eq $false){
    $client = new-object System.Net.WebClient 
    $cookie = "oraclelicense=accept-securebackup-cookie"
    $client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, $cookie) 

    echo "Downloading Java JDK"
    
    #$client.downloadFile($__javaDownloadUrl, $__tempFolder + "\java.exe")
    #HACK --- only for testing... uncomment the line above
    cp java.exe $__tempFolder

    echo "Java Downloaded"
    echo "Installing Java to " $env:JAVA_HOME


    $arguments = @(
	    '/s', "/v/qn`" INSTALLDIR=\`"$env:JAVA_HOME\`" REBOOT=Supress IEXPLORER=0 MOZILLA=0 /L \`"java-install.log\`"`""
    )

    $proc = Start-Process $__tempFolder"\java.exe" -ArgumentList $arguments -Wait -PassThru

    if($proc.ExitCode -ne 0) {
	    Throw "ERROR"
    }
    echo "Java Installed"
}

if($env:JAVA_HOME -eq ""){
    [System.Environment]::SetEnvironmentVariable('JAVA_HOME', $env:JAVA_HOME, 'machine')
    echo "JAVA_HOME environment variable set"
}


#Check it see if ant is installed
$antInstalled = $false

try{
    $out = &"ant" -version 2>&1
    $antver = $out[0].tostring();
    $antInstalled = ($antver -gt "")
}catch {
    $antInstalled = $false
}

#If ant is not installed...
if($antInstalled -eq $false){

    echo "Downloading ant"
  
    #Invoke-WebRequest $__antDownloadUrl -OutFile $__tempFolder"\ant.zip"
    #HACK --- only for testing... uncomment the line above
  
    cp ant.zip $__tempFolder
  
    echo "Ant Downloaded"

    echo "Installing Ant"
    
    if(Test-Path $env:ANT_HOME){
	    Remove-Item $env:ANT_HOME -recurse
    }

    #New-Item $env:ANT_HOME -Type directory -Force
    
    [System.IO.Compression.ZipFile]::ExtractToDirectory($__tempFolder + "\ant.zip", $env:ANT_HOME + "\..\")

    Move-Item $env:ANT_HOME"\..\"$__antFolderName $env:ANT_HOME

}

if($env:ANT_HOME -eq ""){
    [System.Environment]::SetEnvironmentVariable('ANT_HOME', $env:ANT_HOME, 'machine')
    echo "ANT_HOME environment variable set"
}


if(![System.Environment]::GetEnvironmentVariable("PATH").Contains($env:JAVA_HOME)){

    echo "Updating Path"

    $__pathToAppend =  $env:JAVA_HOME + "\bin;" + $env:ANT_HOME + "\bin;"


    #TODO verify that the current path ends with ;

    echo $__pathToAppend

    [System.Environment]::SetEnvironmentVariable("PATH", $env:PATH + $__pathToAppend, "Machine")


    #Refresh env
    foreach($level in "Machine","User") {

        [Environment]::GetEnvironmentVariables($level).GetEnumerator() | % {
        
            # For Path variables, append the new values, if they're not already in there
            if($_.Name -match 'Path$') { 
                $_.Value = ($((Get-Content "Env:$($_.Name)") + ";$($_.Value)") -split ';' | Select -unique) -join ';'
            }

            $_

        } | Set-Content -Path { "Env:$($_.Name)" }


    }

   echo "Path Set" 
   [System.Environment]::GetEnvironmentVariable("PATH")


}

