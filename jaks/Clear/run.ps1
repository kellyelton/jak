## SCRIPT NAME 'New-App.psi'
# This script stores an example application in memory.
# It is called by another application.
# This script should not write any files to disk!
#
# Do not touch the file system
# KEEP THE CODE AS SHORT AND CONCISE AS POSSIBLE!!
#
# Application Language: python
# Application Name: Clear
# Application description and free-form requirements:
<#
Clear the current console window
#>

$APPNAME = "Clear"
$main_script = "Clear.py"

$global:application_files = @()

function New-ApplicationFile {
    param (
        $name,
        $contents
    )

    $af = [System.Collections.ArrayList]$global:application_files

    $af.Add(@($name, $contents))

    $global:application_files = $af
}

# Example of how to properly write a multiline string in powershell
$multiline_string = @"

print("this is a test")

"@

# This script will not work with any comments after this line

# The end of this file should not include any comments, just quit.

$main_script_contents = @"

import os
import sys
import subprocess

def clear():
    os.system('cls' if os.name == 'nt' else 'clear')

clear()

"@

New-ApplicationFile -name $main_script -contents $main_script_contents




$out_dir = "$PWD/out/$APPNAME"

if (!(Test-Path $out_dir)) { New-Item -ItemType Directory -Force -Path $out_dir }

# write files
foreach ($file in $global:application_files) {
    $fname = $file[0]
    $fcontents = $file[1]
    $path = "$out_dir/$fname"
    Write-Host "Creating file $path"
    [System.IO.File]::WriteAllText($path, $fcontents)
}

# change cwd
Set-Location -Path "$out_dir"

try{
    & python $main_script
} catch {
    Write-Host "Error running main script: $($_.Exception.Message)"
}

Set-Location -Path "$pwd"
