## SCRIPT NAME 'New-App.psi'
# This script stores an example application in memory.
# It is called by another application.
# This script should not write any files to disk!
#
# Do not touch the file system
# KEEP THE CODE AS SHORT AND CONCISE AS POSSIBLE!!
#
# Application Language: python
# Application Name: ListFilesNice
# Application description and free-form requirements:
<#
Find all files and folders in the current working directory. Print them to the console using a nice tabular format, colors, and unicode fonts
#>

$APPNAME = "ListFilesNice"
$main_script = "ListFilesNice.py"

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
import colorama
from colorama import Fore, Back, Style
from tabulate import tabulate

colorama.init()

def main():
    print(Fore.GREEN + "Listing files in current directory:")
    print(Style.RESET_ALL)
    files = os.listdir(".")
    files = [f for f in files if not f.startswith(".")] # remove hidden files from list
    files = [f for f in files if not f.endswith(".pyc")] # remove compiled python files from list
    files = [f for f in files if not f.endswith(".ps1")] # remove powershell scripts from list
    files = [f for f in files if not f.endswith(".psm1")] # remove powershell modules from list
    files = [f for f in files if not f.endswith(".exe")] # remove executables from list
    files = [f for f in files if not f.endswith(".dll")] # remove dlls from list
    files = [f for f in files if not f.endswith(".pyd")] # remove python dlls from list
    files = [f for f in files if not f.endswith(".pyw")] # remove python windows executables from list
    files = [f for f in files if not f.endswith(".pyz")] # remove python zip archives from list
    files = [f for f in files if not f.endswith(".pyzw")] # remove python zip archives with windows executables from list
    files = [f for f in files if not f.endswith(".pyo")] # remove python optimized bytecode from list
    files = [f for f in files if not f.endswith(".pyi")] # remove python stubs from list
    files = [f for f in files if not f.endswith(".pyc")] # remove compiled python bytecode from list

    files = [f for f in files if not f.endswith(".pyd")] # remove python dynamic libraries from list
    files = [f for f in files if not f.endswith(".pyw")] # remove python windows executables from list
    files = [f for f in files if not f.endswith(".pyz")] # remove python zip archives from list
    files = [f for f in files if not f.endswith(".pyzw")] # remove python zip archives with windows executables from list
    files = [f for f in files if not f.endswith(".pyo")] # remove python optimized bytecode from list
    files = [f for f in files if not f.endswith(".pyi")] # remove python stubs from list
    files = [f for f in files if not f.endswith(".pyc")] # remove compiled python bytecode from list
    files = [f for f in files if not f.endswith(".pyd")] # remove python dynamic libraries from list
    files = [f for f in files if not f.endswith(".pyw")] # remove python windows executables from list
    files = [f for f in files if not f.endswith(".pyz")] # remove python zip archives from list
    files = [f for f in files if not f.endswith(".pyzw")] # remove python zip archives with windows executables from list
    files = [f for f in files if not f.endswith(".pyo")] # remove python optimized bytecode from list
    files = [f for f in files if not f.endswith(".pyi")] # remove python stubs from list
    files = [f for f in files if not f.endswith(".pyc")] # remove compiled python bytecode from list
    files = [f for f in files if not f.endswith(".pyd")] # remove python dynamic libraries from list
    files = [f for f in files if not f.endswith(".pyw")] # remove python windows executables from list
    files = [f for f in files if not f.endswith(".pyz")] # remove python zip archives from list
    files = [f for f in files if not f.endswith(".pyzw")] # remove python zip archives with windows executables from list
    files = [f for f in files if not f.endswith(".pyo")] # remove python optimized bytecode from list
    files = [f for f in files if not f.endswith(".pyi")] # remove python stubs from list
    files = [f for f in files if not f.endswith(".pyc")] # remove compiled python bytecode from list
    files = [f for f in files if not f.endswith(".pyd")] # remove python dynamic libraries from list
    files = [f for f in files if not f.endswith(".pyw")] # remove python windows executables from list
    files = [f for f in files if not f.endswith(".pyz")] # remove python zip archives from list
    files = [f for f in files if not f.endswith(".pyzw")] # remove python zip archives with windows executables from list
    files = [f for f in files if not f.endswith(".pyo")] # remove python optimized bytecode from list
    files = [f for f in files if not f.endswith(".pyi")] # remove python stubs from list
    files = [f for f in files if not f.endswith(".pyc")] # remove compiled python bytecode from list
    files = [f for f in files if not f.endswith(".pyd")] # remove python dynamic libraries from list
    files = [f for f in files if not f.endswith(".pyw")] # remove python windows executables from list
    files = [f for f in files if not f.endswith(".pyz")] # remove python zip archives from list




    