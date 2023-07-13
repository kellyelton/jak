function Invoke-Jak {
    [CmdletBinding()]
    [Alias("jaki")]
    param (
        [string]$name
    )

    $Debug = $PSBoundParameters.Debug

    Write-Debug "Debug mode enabled"

    if ($null -eq $name) {
        Write-Error "Name is required"
        return
    }

    # current working directory, not script directory
    $INITIAL_PATH = $PWD

    $USER_DATA_PATH = Resolve-Path "~\.jak"

    Write-Debug "User data path: $USER_DATA_PATH"

    if (!(Test-Path $USER_DATA_PATH)) {
        Write-Debug "User data path does not exist. Creating..."
        New-Item -ItemType Directory -Path $USER_DATA_PATH | Out-Null
    }

    $APPS_ROOT = Resolve-Path "$USER_DATA_PATH\jaks"
    $APP_ROOT = "$APPS_ROOT\$name"

    Write-Debug "App root: $APP_ROOT"

    if (!(Test-Path $APP_ROOT)) {
        Write-Error "App $name doesn't exist"
        return
    }

    $APP_PATH = "$APP_ROOT\launch.ps1"

    Write-Debug "App path: $APP_PATH"

    if (!(Test-Path $APP_PATH)) {
        Write-Error "App $name missing app file"
        return
    }

    Write-Debug "Changing directory to $APP_ROOT"
    Set-Location $APP_ROOT
    try {
        & $APP_PATH
    } finally {
        Set-Location $INITIAL_PATH
    }
}

Export-ModuleMember -Function Invoke-Jak -Alias * -ErrorAction SilentlyContinue