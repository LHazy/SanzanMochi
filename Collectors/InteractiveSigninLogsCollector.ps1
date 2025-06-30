class InteractiveSigninLogsCollector : AbstructCollector {
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
        [InteractiveSigninLogsCollector] $collector
    )

    if (-Not $collector.isEnabled) {
        Write-Host "InteractiveSigninLogsCollector is not enabled."
        return
    }

    $collector.DoCollect()
}