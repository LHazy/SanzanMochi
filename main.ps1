using module ./Collectors/BaseController.psm1

Import-Module Microsoft.Graph.Authentication

function Load-GlobalConfig {
    param (
        [string] $filePath
    )

    Import-Module ./utils/ConfigLoader.ps1 -Force

    if (-Not (Test-Path $filePath)) {
        Write-Error "Configuration file not found: $filePath"
        return $null
    }
    
    return Load-Config -filePath $filePath
}

function New-GeneralCollector {
    [CmdletBinding()]
    param (
        [string] $collectorName,
        [hashtable] $globalConfig = $globalConfig
    )

    $psFile = Get-Item -Path "./Collectors/$collectorName.ps1"
    if (-Not $psFile) {
        Write-Error "Collector class not found: $collectorName"
        return $null
    }

    $klass = Import-Module $psFile.FullName -Force
    $constructor = $klass["new"]

    if (-Not $constructor) {
        Write-Error "Constructor not found for collector: $collectorName"
        return $null
    }

    return $constructor.Invoke($globalConfig)
}

function Execute-GeneralCollector {
    [CmdletBinding()]
    param (
        [BaseCollector] $collector,
        [hashtable] $globalConfig = $globalConfig
    )

    if (-Not $collector.isEnabled) {
        Write-Host "$($collector.GetType().Name) is not enabled."
        return
    }
    
    $collector.DoCollect()
}


function Main() {
    [CmdletBinding()]
    param ()
 
    if ($null -eq $globalConfig) {
        $globalConfig = Load-GlobalConfig -filePath "config.ini"
        Set-Variable -Name $globalConfig -Value $globalConfig -Option ReadOnly
    }

    $toolConfig = $globalConfig["Tool"]
    $tenantId = $toolConfig["TenantId"]
    $clientId = $toolConfig["ClientId"]

    $enabledCollectors = @()
    foreach ($section in $globalConfig.Keys) {
        if ($section -eq "Tool" -or -not $globalConfig[$section]["Enabled"]) {
            continue
        }

        $collector = New-GeneralCollector -collectorName $section -globalConfig $globalConfig
        if ($collector) {
            $enabledCollectors += $collector
        }
    }

    $requiredScopes = @()
    foreach ($collector in $enabledCollectors) {
        if ($collector.requireScopes -and $collector.requireScopes.Count -gt 0) {
            $requiredScopes += $collector.requireScopes
        }
    } 
    $requiredScopes = $requiredScopes | Select-Object -Unique

    Write-Host "Connecting to Microsoft Graph with Tenant ID: $tenantId, Client ID: $clientId, Scopes: $($requiredScopes -join ', ')"
    $clientSecretCredential = Get-Credential -Credential $clientId
    if (-not $clientSecretCredential) {
        Write-Error "Failed to get client secret credential."
        return
    }

    Connect-MgGraph -TenantId $tenantId -ClientSecretCredential $clientSecretCredential

    foreach ($collector in $enabledCollectors) {
        Write-Host "Executing collector: $($collector.GetType().Name)"
        Execute-GeneralCollector -collector $collector -globalConfig $globalConfig
    }
}

Main