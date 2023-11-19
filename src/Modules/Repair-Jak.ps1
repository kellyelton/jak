function Repair-Jak {
    param (
        [string]$Name,
        [string]$Instructions
    )

    $USER_DATA_PATH = "~\.jak"

    if (!(Test-Path $USER_DATA_PATH)) {
        Write-Verbose "User data path does not exist. Creating..."
        New-Item -ItemType Directory -Path $USER_DATA_PATH | Out-Null
    }

    $APPS_ROOT = Resolve-Path "$USER_DATA_PATH\jaks"

    # Name is required, throw error and exit if no name
    if ($null -eq $Name) {
        Write-Error "Name is required"
        return
    }

    $APP_ROOT = "$APPS_ROOT\$Name"

    # If the app doesn't exist, throw error and exit
    if (!(Test-Path $APP_ROOT)) {
        Write-Error "App $Name doesn't exist"
        return
    }

    $FIX_APP_PATH = "$APP_ROOT\fix.ps1"

    # If the app doesn't have a ps1 file, throw error and exit
    if (!(Test-Path $APP_PATH)) {
        Write-Error "App $Name doesn't have a fixer upper file"
        return
    }

    # Run the fixer upper file
    & $FIX_APP_PATH $Instructions
}

#if ($PSCommandPath -eq $MyInvocation.MyCommand.Path) {
#    # pass the args to the function
#    New-Jak @args
#}

# export the function
Export-ModuleMember Repair-Jak -ErrorAction SilentlyContinue
