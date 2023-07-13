## SCRIPT NAME 'New-App.psi'
# This script stores an example application in memory.
# It is called by another application.
# This script should not write any files to disk!
#
# Do not use <code> tags in this file
# Do not touch the file system
# NO COMMENTS PLEASE ONCE THE CODE STARTS!!!
# KEEP THE CODE AS SHORT AND CONCISE AS POSSIBLE!!
#
# Application Language: python
# Application Name: SayHi
# Application description and free-form requirements:
<#
Say hello to the user
#>

$APPNAME = "SayHi"
$main_script = "SayHi.py"

$application_files = @{}

function New-ApplicationFile {
    param (
        $name,
        $contents
    )

    $global:application_files += @{ name = "$out_dir/$name"; contents = $contents }
}

$main_script_contents = @"
#!/usr/bin/env python

print("Hello, world!")
"@
New-ApplicationFile -name $main_script -contents $main_script_contents</code>




$out_dir = "$PWD/out/$APPNAME"

if (!(Test-Path $out_dir)) { New-Item -ItemType Directory -Force -Path $out_dir }

# write files
foreach ($file in $application_files) {
    Write-Host "Creating file $($file.name)"
    [System.IO.File]::WriteAllText($file.name, $file.contents)
}

# change cwd
Set-Location -Path "$out_dir"

try{
    & python $main_script
} catch {
    Write-Host "Error running main script: $($_.Exception.Message)"
}

Set-Location -Path "$pwd"
