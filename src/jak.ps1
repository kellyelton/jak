param (
    [string]$name,
    [string]$details,
    [switch]$Debug
)

# current working directory, not script directory
$INITIAL_PATH = $PWD
$APP_ROOT = $PSScriptRoot

# if name is not provided, set to HelloWorld
if ($null -eq $name) {
    $name = "HelloWorld"
}

# if details is not provided, set to Hello world app. Just prints hello world and waits for the user to press enter.
if ($null -eq $details) {
    $details = "Hello world app. Just prints hello world and waits for the user to press enter."
}

$language = "python"

$bearerFile = "$APP_ROOT\bearer.txt"
$bearer = if (Test-Path $bearerFile) { Get-Content $bearerFile } else {
    # If the bearer.txt file doesn't exist, ask the user to paste their bearer token.
    Write-Host "You need to get a bearer token from https://beta.openai.com/account/api-keys"
    Write-Host ""

    # Launch the browser to the OpenAI API keys page.
    Start-Process "https://beta.openai.com/account/api-keys"

    Write-Host "Please paste your bearer token here: " 
    [string]$bearer = Read-Host
    
    # Store the bearer token to a bearer.txt file in the same folder.
    Set-Content -Path $bearerFile -Value $bearer

    return $bearer 
}

# remove the temp files
Remove-Item -Path "$APP_ROOT\request.txt" -ErrorAction SilentlyContinue | Out-Null
Remove-Item -Path "$APP_ROOT\response.txt" -ErrorAction SilentlyContinue | Out-Null
Remove-Item -Path "$APP_ROOT\prompt.txt" -ErrorAction SilentlyContinue | Out-Null
# clear out the out subdir
Remove-Item -Path "$APP_ROOT\out\$name" -Recurse -ErrorAction SilentlyContinue | Out-Null
#delete ps1 file if it exsts
Remove-Item -Path "$APP_ROOT\$name.ps1" -ErrorAction SilentlyContinue | Out-Null

# add the prompt to the template
$prompt_template = [system.io.file]::ReadAllText("$APP_ROOT\template.txt")
if ($Debug) {
    Write-Host "Prompt Template: $prompt_template"
}

# replace the text [PROMPT] with the prompt 
$prompt = $prompt_template -replace "\[PROMPT\]", $details
$prompt = $prompt -replace "\[APPNAME\]", $name
$prompt = $prompt -replace "\[APPLANGUAGE\]", $language

if ($Debug) {
    Write-Host "Full Prompt: $prompt"
}

# make $prompt a string, and conver the new lines to \n
#$prompt = $prompt -replace "`"", "\`"" # replace " with \"
#$prompt = $prompt -replace "`r`n", "\n"
#$prompt = $prompt -replace "`n", "\n"

if ($Debug) {
    # Write request details to request.txt
    $prompt | Out-File -FilePath "$APP_ROOT\prompt.txt" | Out-Null
}

# write script file
$path = "$APP_ROOT\$name.ps1"

# append $prompt to $path file
$prompt | Out-File -FilePath $path -NoNewline | Out-Null


$headers = @{ 
    Authorization="Bearer $bearer";
    "Content-Type"="application/json";
    "User-Agent"="Jak/0.1";
}

while ($true)
{
    $body_text = [system.io.file]::ReadAllText($path).TrimEnd()
    #$body_text = "int mai"
    $body = @{ 
       "temperature"=0;
        "max_tokens"=250;
        "top_p"=1;
        "frequency_penalty"=0.2;
        "presence_penalty"=0.2;
        "best_of"=3;
        "stream"=$false;
        "prompt"=$body_text;
        "logprobs"=0;
        "echo"=$false;
        "stop"="@' DONE '@";
    } | ConvertTo-Json 

    if ($Debug) {
        # dump request to request.txt
        $body | Out-File -FilePath "$APP_ROOT\request.txt" -NoNewline | Out-Null
    }

    # send request
    # use proxy at localhost:8888
    $response = Invoke-RestMethod -Method Post -Uri 'https://api.openai.com/v1/engines/code-davinci-002/completions' -Headers $headers -Body $body -ContentType "application/json" -StatusCodeVariable "status_code"
    
    if ($Debug) {
        $respBody = $response | ConvertTo-Json
        # dump response to response.txt
        $respBody | Out-File -FilePath "$APP_ROOT\response.txt" -NoNewline -ErrorAction SilentlyContinue | Out-Null
    }

    $choice = $response | Select-Object -ExpandProperty choices | Select-Object -First 1

    if ($null -eq $choice) {
        Write-Host "No choices found"
        return
    }

    $choice_text = $choice | Select-Object -ExpandProperty text

    # if choice_text ends with a "@, move it to the next line
    $choice_text = $choice_text -replace "`"@$", "`r`n`"@"
    $choice_text = $choice_text -replace "</code>", ""

    $choice_text | Out-File -FilePath $path -Append -NoNewline | Out-Null

    if ($choice.finish_reason -eq "stop") {
        break
    }
}

$end_code = @'

$out_dir = "$PWD/out/$APPNAME"

if (!(Test-Path $out_dir)) { New-Item -ItemType Directory -Force -Path $out_dir | Out-Null }

# write files
foreach ($file in $global:application_files) {
    $fname = $file[0]
    $fcontents = $file[1]
    $path = "$out_dir/$fname"
    [System.IO.File]::WriteAllText($path, $fcontents)
}

$cur_dir = $PWD

# change cwd
Set-Location -Path "$out_dir"

try{
    & python $main_script
} catch {
    Write-Host "Error running main script: $($_.Exception.Message)"
} finally {
    Set-Location -Path "$cur_dir"
}
'@

$end_code | Out-File -FilePath $path -Append | Out-Null

# run the script
try{
    & $path
} catch {
    Write-Host "Error running main script ($path): $($_.Exception.Message)"
}