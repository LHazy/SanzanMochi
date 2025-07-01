class InteractiveSigninLogsCollector : BaseCollector {
    [string] $iniSection = "InteractiveSigninLogsCollector"

    InteractiveSigninLogsCollector() { }
    InteractiveSigninLogsCollector([hashtable] $globalConfig) {
        $this.globalConfig = $globalConfig
        $this.LoadConfig()
    }

    DoCollect() {
        # Get-MgBetaAuditLogSignIn -Filter "signInEventTypes/any(t: t eq 'interactiveUser')"
        Write-Host "Collecting interactive sign-in logs..."
    }
}

return @{
    klass = [InteractiveSigninLogsCollector]
    new = [InteractiveSigninLogsCollector]::new
}