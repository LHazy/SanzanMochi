class InteractiveSigninLogsCollector : BaseCollector {
    [string] $iniSection = "InteractiveSigninLogsCollector"

    InteractiveSigninLogsCollector() { }
    InteractiveSigninLogsCollector([hashtable] $globalConfig) {
        $this.globalConfig = $globalConfig
        $this.LoadConfig()
    }

    DoCollect() {
        Get-MgBetaAuditLogSignIn -Filter "signInEventTypes/any(t: t eq 'interactiveUser')" 
    }
}

function New-InteractiveSigninLogsCollector {
    [CmdletBinding()]
    param (
        [hashtable] $globalConfig = $globalConfig
    )

    return [InteractiveSigninLogsCollector]::new($globalConfig)
}

function Execute-InteractiveSigninLogsCollector {
    [CmdletBinding()]
    param (
        [InteractiveSigninLogsCollector] $globalConfig
    )

    if (-Not $collector.isEnabled) {
        Write-Host "InteractiveSigninLogsCollector is not enabled."
        return
    }

    $collector = New-InteractiveSigninLogsCollector -globalConfig $globalConfig
    if (-Not $collector) {
        Write-Error "Failed to create InteractiveSigninLogsCollector."
        return
    }
    
    if (-Not $collector.isConfigured) {
        Write-Error "InteractiveSigninLogsCollector is not configured properly."
        return
    }
    
    $collector.DoCollect()
}