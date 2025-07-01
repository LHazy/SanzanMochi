using module ./Collectors/BaseController.psm1

function Collect-AllRequiredScopes {
    [CmdletBinding()]
    param (
        [hashtable] $globalConfig = $globalConfig
    )

    $requiredScopes = @()
    foreach ($section in $globalConfig.Keys) {
        if ($section -eq "Tool" -or -not $globalConfig[$section]["Enabled"]) {
            continue
        }

        if ($globalConfig[$section].ContainsKey("RequireScopes")) {
            $requiredScopes += $globalConfig[$section]["RequireScopes"]
        }
    }

    $requiredScopes = $requiredScopes | Select-Object -Unique
    return $requiredScopes
}

function Load-GlobalConfig {
    param (
        [string] $filePath
    )

    Import-Module ./utils/ConfigLoader.ps1

    if (-Not (Test-Path $filePath)) {
        Write-Error "Configuration file not found: $filePath"
        return $null
    }
    
    return Load-Config -filePath $filePath
}

if ($null -eq $globalConfig) {
    $globalConfig = Load-GlobalConfig -filePath "config.ini"
    Set-Variable -Name $globalConfig -Value $globalConfig -Option ReadOnly
}

$toolConfig = $globalConfig["Tool"]
$tenantId = $toolConfig["TenantId"]
$clientSecretCredential = $toolConfig["ClientSecretCredential"]

$requiredScopes = Collect-AllRequiredScopes -globalConfig $globalConfig
Write-Host "Required Scopes: $($requiredScopes -join ', ')"

# Connect-MgGraph -TenantId $tenantId -ClientSecretCredential $clientSecretCredential -Scopes $requiredScopes
