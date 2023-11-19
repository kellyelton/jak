function New-Jak {
    param (
        [string]$name,
        [string]$details,
        [string]$language = "py",
        [switch]$Debug = $false,
        [switch]$Force = $false
    )

    #$name = "eatshit"
    #$details = "Fullscreen 3d hello world"
    #$Force = $true

    $API_BASE = "https://api.openai.com/v1/chat/completions"
    #$API_BASE = "http://localhost:1234/v1/chat/completions"
    $API_KEY = "sk-1234567890abcdef1234567890abcdef"
    $AI_MODEL = "gpt-4-1106-preview"

    $languageext = ""
    $languageexe = ""
    if ($language -eq "python" -or $language -eq "py" -or $language -eq "python3" -or $language -eq "py3") {
        $languageext = "py"
        $languageexe = "python"
    } elseif ($language -eq "node" -or $language -eq "nodejs" -or $language -eq "njs" -or $language -eq "node.js") {
        $languageext = "js"
        $languageexe = "node"
    } else {
        # not supported
        Write-Error "Language $language is not supported"
        return
    }

    # current working directory, not script directory
    $INITIAL_PATH = $PWD

    $USER_DATA_PATH = "~\.jak"

    if (!(Test-Path $USER_DATA_PATH)) {
        Write-Verbose "User data path does not exist. Creating..."
        New-Item -ItemType Directory -Path $USER_DATA_PATH | Out-Null
    }

    $APPS_ROOT = Resolve-Path "$USER_DATA_PATH\jaks"
    $TEMPLATES_ROOT = Resolve-Path "$USER_DATA_PATH\templates"

    $TEMPLATE__NEW = "$TEMPLATES_ROOT\new.txt"
    $TEMPLATE__NEW_INSTRUCTION = "$TEMPLATES_ROOT\new_instruction.txt"

    # if name is not provided, set to HelloWorld
    if ($null -eq $name) {
        $name = "HelloWorld"
    }

    # if details is not provided, set to Hello world app. Just prints hello world and waits for the user to press enter.
    if ($null -eq $details) {
        $details = "Hello world app. Just prints hello world and waits for the user to press enter."
    }

    $APP_ROOT = "$APPS_ROOT\$name"
    $DEBUG_ROOT = "$APP_ROOT\debug"

    if ($Debug) {
        Write-Verbose "Debug mode is on."
        Write-Host "CWD: $INITIAL_PATH"
        Write-Host "Apps root: $APPS_ROOT"
        Write-Host "Templates root: $TEMPLATES_ROOT"
        Write-Host "Template new: $TEMPLATE__NEW"
        Write-Host "Template new instruction: $TEMPLATE__NEW_INSTRUCTION"
        Write-Host "App root: $APP_ROOT"
        Write-Host "Debug root: $DEBUG_ROOT"
        Write-Host "Language: $language"
        Write-host "---"
    }

    $BEARER_PATH = "$USER_DATA_PATH\auth.txt"
    $BEARER_PATH = Resolve-Path $BEARER_PATH


    [string]$bearer = ""
    if (Test-Path $BEARER_PATH) {
        # read file into $bearer
        $bearer = [system.io.file]::ReadAllText($BEARER_PATH).TrimEnd()
    }
    else {
        # If the bearer.txt file doesn't exist, ask the user to paste their bearer token.
        Write-Host "You need to get a bearer token from https://beta.openai.com/account/api-keys"
        Write-Host ""

        # Launch the browser to the OpenAI API keys page.
        Start-Process "https://beta.openai.com/account/api-keys"

        Write-Host "Please paste your bearer token here: " 
        [string]$bearer = Read-Host -NoNewline
    
        # Store the bearer token to a bearer.txt file in the same folder.
        $bearer | Out-File -FilePath $BEARER_PATH -NoNewline | Out-Null
    }

    # Check if the app already exists
    if (Test-Path $APP_ROOT) {
        if ($Force) {
            Write-Warning "App already exists. Overwriting..."
            
            # clear out the out subdir
            Remove-Item -Path "$APP_ROOT\*" -Recurse
        }
        else {
            Write-Host "App already exists. Please choose a different name, or use the -Force parameter to overwrite the existing app."
            return
        }
    }

    # create the app directory if it doesn't exist
    if (!(Test-Path $APP_ROOT)) {
        New-Item -ItemType Directory -Path $APP_ROOT | Out-Null
    }

    # create the debug directory if it doesn't exist
    if (!(Test-Path $DEBUG_ROOT)) {
        New-Item -ItemType Directory -Path $DEBUG_ROOT | Out-Null
    }

    # read template file
    [string]$prompt_template = [system.io.file]::ReadAllText($TEMPLATE__NEW)
    [string]$instruction_template = [system.io.file]::ReadAllText($TEMPLATE__NEW_INSTRUCTION)

    # replace the text [PROMPT] with the prompt 
    $prompt = $prompt_template -replace "\[PROMPT\]", $details
    $prompt = $prompt -replace "\[APPNAME\]", $name
    $prompt = $prompt -replace "\[APPLANGUAGE\]", $language
    $prompt = $prompt -replace "\[APPEXTENSION\]", $languageext

    $instructions = $instruction_template -replace "\[PROMPT\]", $details
    $instructions = $instructions -replace "\[APPNAME\]", $name
    $instructions = $instructions -replace "\[APPLANGUAGE\]", $language
    $instructions = $instructions -replace "\[APPEXTENSION\]", $languageext

    if ($Debug) {
        # Write request details to request.txt
        $prompt | Out-File -FilePath "$DEBUG_ROOT\prompt.txt" | Out-Null
        $instruction_template | Out-File -FilePath "$DEBUG_ROOT\instruction.txt" | Out-Null
    }

    # write script file
    $path = "$APP_ROOT\build.ps1"

    # append $prompt to $path file
    $prompt | Out-File -FilePath $path -NoNewline | Out-Null


    $headers = @{ 
        Authorization  = "Bearer $bearer";
        "Content-Type" = "application/json";
        "User-Agent"   = "Jak/0.2";
    }

    function Generate-Code() {
        param (
            [string]$path,
            [string]$instructions,
            [string]$model,
            $headers
        )

        if (-not (Test-Path $path)) {
            Write-Error "Prompt file does not exist: $path"
            return $false
        }

        if (-not $instructions) {
            Write-Warning "Instructions are empty"
        }

        for ($i = 0; $i -lt 5; $i++) {
            # Update progress bar
            Write-Progress -Activity "Initializing..." -Status "Iteration $i" -PercentComplete ($i * 20)
            
            $body_text = [system.io.file]::ReadAllText($path)

            $body = @{ 
                "temperature"       = 0.0; # this value represents the randomness of the model. 0 means the model will always choose the most likely word
                "max_tokens"        = 400;
                "top_p"             = 1;
                "frequency_penalty" = 0.4; # this value means the model will try to avoid repeating the same words
                "presence_penalty"  = 0.0; # this value represents the probability of the model repeating the same text
                "stream"            = $false;
                "model"             = $model;
                "stop"              = "@' DONE '@";
                "messages"          = @(
                    @{
                        "role" = "system";
                        "content"= $instructions;
                    },
                    @{
                        "role" = "user";
                        "content"= $body_text;
                    }
                );
            } | ConvertTo-Json 

            if ($Debug) {
                # dump request to request.txt
                $body | Out-File -FilePath "$DEBUG_ROOT\request.txt" -NoNewline | Out-Null
            }

            # send request
            # use proxy at localhost:8888
            $url = $API_BASE
            $response = Invoke-RestMethod -Method Post -Uri $url -Headers $headers -Body $body -ContentType "application/json" -StatusCodeVariable "status_code"
    
            if ($Debug) {
                $respBody = $response | ConvertTo-Json
                # dump response to response.txt
                $respBody | Out-File -FilePath "$DEBUG_ROOT\response.txt" -NoNewline -ErrorAction SilentlyContinue | Out-Null
            }

            $choice = $response | Select-Object -ExpandProperty choices | Select-Object -First 1

            if ($null -eq $choice) {
                Write-Host "No choices found"
                return $false
            }

            $message = $choice | Select-Object -ExpandProperty message

            if ($null -eq $message) {
                Write-Host "No message found"
                return $false
            }

            $content = $message | Select-Object -ExpandProperty content

            if ($null -eq $content) {
                Write-Host "No content found"
                return $false
            }

            $choice_text = $content

            # if choice_text ends with a "@, move it to the next line
            $choice_text = $choice_text -replace "`"@$", "`r`n`"@"
            $choice_text = $choice_text -replace "</code>", ""

            $choice_text | Out-File -FilePath $path -Append -NoNewline | Out-Null

            if ($choice.finish_reason -eq "stop") {
                return $true
            }
        }
    }

    while ($true) {
        $completed = Generate-Code -path $path -headers $headers -instructions $instructions -model $AI_MODEL

        if ($completed) {
            write-host "Code generation completed."
            Write-Host
            break
        }

        ##TODO: Run through AI again and ask it to make sure the code is complete.

        Write-Host "Failed to generate code!"
        write-Host " - $path"
        Write-Host " - Press 'e' to open the file in vscode"
        Write-Host " - Press 'y' to continue generating code"
        Write-Host " - Press any other key to abort"        

        $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        if ($key.VirtualKeyCode -eq 89) {
            # continue
            continue
        } elseif ($key.VirtualKeyCode -eq 69) {
            # open file in VSCode, program files
            $vscode_path = "C:\Program Files\Microsoft VS Code\Code.exe"
            & $vscode_path "$path"
        } else {
            Write-Host "Aborting..."
            return
        }
    }

    $end_code = @'

# write files
foreach ($file in $global:application_files) {
    $fname = $file[0]
    $fcontents = $file[1]
    $path = ".\$fname"
    Write-Debug "Writing file: $path"
    $fcontents | Out-File -FilePath $path -NoNewline -Force | Out-Null
}
'@

    $end_code | Out-File -FilePath $path -Append | Out-Null

    $LAUNCH_PATH = "$APP_ROOT\launch.ps1"

    # write the launch.ps1 file
    $launch_code = "& $languageexe `"app.$languageext`""

    $launch_code | Out-File -FilePath $LAUNCH_PATH -NoNewline | Out-Null

    $built = $false
    Write-Debug "Changing directory to $APP_ROOT"
    Set-Location $APP_ROOT
    try {
        & $path
        $built = $true
    }
    catch {
        Write-Host "Error building ($path): $($_.Exception.Message)"
    }
    finally {
        Set-Location $INITIAL_PATH
    }

    if ($built) {
        Set-Location $APP_ROOT
        try {
            & $LAUNCH_PATH
        }
        catch {
            Write-Host "Error running app ($LAUNCH_PATH): $($_.Exception.Message)"
        }
        finally {
            Set-Location $INITIAL_PATH
        }
    }
}

# if this is the main script, run the function
if ($PSCommandPath -eq $MyInvocation.MyCommand.Path) {
    # pass the args to the function
    New-Jak @args
}

# if this is being imported, export the function
#Export-ModuleMember -Function New-Jak -ErrorAction SilentlyContinue