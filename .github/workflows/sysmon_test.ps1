[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

function install-Sysmon() {
    Write-host "Downloading and Extracting Sysmon..."
    (New-Object Net.WebClient).DownloadFile("https://download.sysinternals.com/files/Sysmon.zip", "$PSScriptRoot\sysmon.zip") # Download latest sysmon
    Expand-Archive "$PSScriptRoot\sysmon.zip" -DestinationPath "$PSScriptRoot"
    Write-host "Applying Sysmon Configuration..."
    #Start-Process "$env:TEMP\n4agent\sysmon64.exe" -ArgumentList "-accepteula -i $PSScriptRoot\n4sysmon-endpoints.xml"  -NoNewWindow -Wait # Install sysmon with config
    $sysmoncmd = "$PSScriptRoot\sysmon64.exe"
    $sysmonarg = ("-accepteula -i $PSScriptRoot\n4sysmon-endpoints.xml").split(" ")
    $sysmonoutput = &$sysmoncmd $sysmonarg
    if ($sysmonoutput -like '*Configuration file validated*') {
        Write-Host "Validation Suceeded - Sysmon config is ready for deployment"
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

install-Sysmon
write-host "Waiting 30 seconds for sysmon events to be generated..."
Start-Sleep 30
test-logging

