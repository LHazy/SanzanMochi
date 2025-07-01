class NonInteractiveSigninLogsCollector : BaseCollector {
    [string] $iniSection = "NonInteractiveSigninLogsCollector"

    NonInteractiveSigninLogsCollector() { }
    NonInteractiveSigninLogsCollector([hashtable] $globalConfig) {
        $this.globalConfig = $globalConfig
        $this.LoadConfig()
    }

    DoCollect() {
        # Get-MgBetaAuditLogSignIn -Filter "signInEventTypes/any(t: t eq 'nonInteractiveUser')"
        Write-Host "Collecting non-interactive sign-in logs..."
    }
}

return @{
    klass = [NonInteractiveSigninLogsCollector]
    new = [NonInteractiveSigninLogsCollector]::new
}