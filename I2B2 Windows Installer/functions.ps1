Add-Type -AssemblyName System.IO.Compression.FileSystem

Write-Host importing functions


function testing{
    Write-Host testing has been called...
}

function local{
    Write-Host local has been called... $testValue
}

function removeTempFolder{
    if(Test-Path $__tempFolder){
	    Remove-Item $__tempFolder -recurse
    }   
}

function createTempFolder{
    
    removeTempFolder

    New-Item $__tempFolder -Type directory -Force
}


function unzip($zipFile, $folderPath, $removeFolder = $false) {


    if($removeFolder -eq $true){

        if(Test-Path $folderPath){
	        Remove-Item $folderPath -recurse
        }
    
        New-Item $folderPath -Type directory -Force
    }

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipFile, $folderPath)

}


function appendToPath($pathToAppend){

    #verify that the current path ends with ; or append it to the start of the pathToAppend
    if(![System.Environment]::GetEnvironmentVariable("PATH").EndsWith(";")){
        $pathToAppend = ";" + $pathToAppend
    }


    echo $pathToAppend

    [System.Environment]::SetEnvironmentVariable("PATH", $env:PATH + $pathToAppend, "Machine")


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



function replaceInFile($InputFile, $OutputFile, $Pattern, $Replacement){
    Get-Content $InputFile | Foreach-Object {$_.Replace($Pattern,  $Replacement)} | Set-Content $OutputFile
}