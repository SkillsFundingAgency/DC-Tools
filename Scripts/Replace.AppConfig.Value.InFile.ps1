param
(
    [Parameter(Mandatory = $true)] [string] $appConfigFile,
    [Parameter(Mandatory = $true)] [string] $AppSettingsKeyName,
    [Parameter(Mandatory = $true)] [string] $AppSettingsKeyValue,
    [Parameter(Mandatory = $false)] [bool] $EnableDebug=$false
)

[boolean] $Found = $false;

if (!(Test-Path -Path $appConfigFile))
{
    Write-Host "File Not Found : $($appConfigFile)" -ForegroundColor Red
}
else
{
    $doc = (Get-Content $appConfigFile) -as [Xml]
    If (!$doc)
    {
        Write-Host "Xml Config empty !!";
    }
    else
    {
        ## Check Connection String for Setting
        $obj = ($doc.configuration.connectionStrings.add | where {$_.Name -eq "$($AppSettingsKeyName)"})

        if (!$obj)
        {
           if ( $EnableDebug) { Write-host "NOT Found in Connection String "; }
        }
        else
        {
            if ( $EnableDebug) { write-host "Before Value : $($obj.connectionString)" }
            $obj.connectionString = $AppSettingsKeyValue

            if ( $EnableDebug) { write-host "after Value : $($obj.connectionString)" }
            $doc.Save($appConfigFile)
            $Found = $true
        }

        ## Check App Settings for Setting
        $obj = ($doc.configuration.appSettings.add | where {$_.Key -eq "$($AppSettingsKeyName)"})

        if (!$obj)
        {
           if ( $EnableDebug) { Write-host "NOT Found in App Settings"; }
        }
        else
        {
            if ( $EnableDebug) { write-host "Before Value : $($obj.value)" }
            $obj.value = $AppSettingsKeyValue

            if ( $EnableDebug) { write-host "after Value : $($obj.value)" }
            $doc.Save($appConfigFile)
            $Found = $true
        }

        #Display if Not Found
        if (!$Found)
        {
           Write-host "NOT Found : $($AppSettingsKeyName)"
        }
    }
}
