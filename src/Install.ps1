# Install the modules

#powershell 7 module dir
$MODULES_ROOT = Resolve-Path "~\Documents\PowerShell\Modules"
$MODULEDIR = "$MODULES_ROOT\Jak"

# Create the modules directory if it doesn't exist
if (!(Test-Path $MODULEDIR)) {
    New-Item -ItemType Directory -Path $MODULEDIR | Out-Null
}

# Create the modules directory if it doesn't exist
if (!(Test-Path "$MODULEDIR\Modules")) {
    New-Item -ItemType Directory -Path "$MODULEDIR\Modules" | Out-Null
}

if (!(Test-Path "~\.jak\templates")) {
    New-Item -ItemType Directory -Path "~\.jak\templates" | Out-Null
}
if (!(Test-Path "~\.jak\jaks")) {
    New-Item -ItemType Directory -Path "~\.jak\jaks" | Out-Null
}

# Copy powershell sub modules
Copy-Item -Path "$PSScriptRoot\..\src\Modules\New-Jak.ps1" -Destination "$MODULEDIR\Modules\New-Jak.ps1" -Force
Copy-Item -Path "$PSScriptRoot\..\src\Modules\Repair-Jak.ps1" -Destination "$MODULEDIR\Modules\Repair-Jak.ps1" -Force
Copy-Item -Path "$PSScriptRoot\..\src\Modules\Invoke-Jak.ps1" -Destination "$MODULEDIR\Modules\Invoke-Jak.ps1" -Force

# Copy powershell module description
Copy-Item -Path "$PSScriptRoot\..\src\Jak.psd1" -Destination "$MODULEDIR\Jak.psd1" -Force

# Copy all templates to the templates directory
Copy-Item -Path "$PSScriptRoot\..\templates\*" -Destination "~\.jak\templates" -Force -Recurse
Copy-Item -Path "$PSScriptRoot\..\jaks\*" -Destination "~\.jak\jaks" -Force -Recurse

# Register the modules

# New-Jak.ps1
# Register the module
#Unregister-PSRepository -Name "New-Jak" -ErrorAction SilentlyContinue
#Unregister-PSRepository -Name "Repair-Jak" -ErrorAction SilentlyContinue
#Unregister-PSRepository -Name "Jak" -ErrorAction SilentlyContinue
#Register-PSRepository -Name "Jak" -SourceLocation "$MODULEDIR" -InstallationPolicy Trusted

Import-Module Jak -Global
