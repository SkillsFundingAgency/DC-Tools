Write-Host "Working Directory: $((Get-Item -Path '.\' -Verbose).FullName)"

# Regex to find references in .csproj file
$privateSettings = "(?i)include=`"PrivateSettings`.config`"(?-i)"
$privateConnectionStrings = "(?i)include=`"PrivateConnectionStrings`.config`"(?-i)"

# Get .csproj files recursively
$filesArr = Get-ChildItem -Filter *.csproj -Recurse -ErrorAction SilentlyContinue -Force

# Iterate each found .csproj file
For ($i=0; $i -lt $filesArr.Length; $i++) {
    Write-Host "Analysing Project: $($filesArr[$i].FullName)" -ForegroundColor Yellow

    $privateSettingsFound = 0
    $privateConnectionStringsFound = 0

    $line = Get-Content $filesArr[$i].FullName;
        if ($line -cmatch $privateSettings)
        {
            $privateSettingsFound = 1
        }
        if ($line -cmatch $privateConnectionStrings) {
            $privateConnectionStringsFound = 1
        }

       write-host "Private settings count: $privateSettingsFound"   -ForegroundColor Green
     write-host "Private connection settings count: $privateConnectionStringsFound"   -ForegroundColor Green
    # If we need to create a privatesettings.config file then check it doesn't exist, and if not create
    if ($privateSettingsFound -eq 1) {
    
        $fileToCreate = "$($filesArr[$i].DirectoryName)\PrivateSettings.config"
        if (-Not(Test-Path $fileToCreate)) {
            Write-Host "Creating: $fileToCreate"
            New-Item $fileToCreate -type file
        }
    }
        
         

  

    # If we need to create a privateconnectionstrings.config file then check it doesn't exist, and if not create
    if ($privateConnectionStringsFound -eq 1) {
  
        $fileToCreate = "$($filesArr[$i].DirectoryName)\PrivateConnectionStrings.config"
        if (-Not (Test-Path $fileToCreate)) {
            Write-Host "Creating: $fileToCreate"
            New-Item $fileToCreate -type file
        }
    }    
}

