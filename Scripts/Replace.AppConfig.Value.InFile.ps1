param
(
    [Parameter(Mandatory = $true)]
    [string]
    $appConfigFile,

    [Parameter(Mandatory = $true)]
    [string]
    $AppSettingsKeyName,

    [Parameter(Mandatory = $true)]
    [string]
    $AppSettingsKeyValue,

    [Parameter(Mandatory = $false)]
    [bool]
    $EnableDebug=$false
)

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
        $obj = ($doc.configuration.connectionStrings.add | where {$_.Name -eq "$($AppSettingsKeyName)"})

        if (!$obj)
        {
            Write-Host "Connection String NOT Found";
        }
        else
        {
            if ( $EnableDebug) { write-host "Before Value : $($obj.connectionString)" }
            $obj.connectionString = $AppSettingsKeyValue

            if ( $EnableDebug) { write-host "after Value : $($obj.connectionString)" }
            $doc.Save($appConfigFile)
        }
    }
}
