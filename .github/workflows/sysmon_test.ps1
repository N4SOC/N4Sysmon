[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

$currentDir = (Get-Location).Path

function install-Sysmon() {
    param (
        [Parameter()] $sysmonfile
    )
        Write-host "Downloading and Extracting Sysmon..."
        (New-Object Net.WebClient).DownloadFile("https://download.sysinternals.com/files/Sysmon.zip", "$currentdir\sysmon.zip") # Download latest sysmon
        Expand-Archive "$currentdir\sysmon.zip" -DestinationPath "$currentdir"
        Write-host "Applying Sysmon Configuration: $sysmonFile"
        $sysmoncmd = "$currentdir\sysmon64.exe"
        $sysmonarg = ("-accepteula -i $currentdir\$sysmonFile").split(" ")
        $sysmonoutput = &$sysmoncmd $sysmonarg
        if ($sysmonoutput -like '*Configuration file validated*') {
            Write-Host "Validation Suceeded - Sysmon config is ready for deployment"
            write-host "Waiting 30 seconds for sysmon events to be generated..."
            Start-Sleep 30
            test-logging

        }
        else {
            Write-Host "Validation Failed - Roll back last commit"  -BackgroundColor DarkRed -ForegroundColor Yellow
        }
}

function test-logging() {
    write-host "Checking for Sysmon Logs..."
    $sysmonlogs = Get-WinEvent -LogName 'Microsoft-Windows-Sysmon/Operational' -MaxEvents 100
    if ($sysmonlogs.Count -gt 0 ) {
        write-host "Events Detected"
    }
    else {
        write-host "No Events Detected" -BackgroundColor DarkRed -ForegroundColor Yellow
    }
}

install-Sysmon -sysmonfile $args[0]

