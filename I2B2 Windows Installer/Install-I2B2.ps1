$__currentDirectory = (Get-Item -Path ".\" -Verbose).FullName
$__tempFolder = $__currentDirectory + "\.temp"
$__sourceCodeRootFolder = $__currentDirectory + "\i2b2core-src"
$__sourceCodeZipFile = $__currentDirectory + "\i2b2core-src-1704.zip"


if(Test-Path $__tempFolder){
	Remove-Item $__tempFolder -recurse
}
New-Item $__tempFolder -Type directory -Force

.{.\Setup.ps1}

.{.\InstallPrereqs.ps1}

#.{.\ExtractSource.ps1}