Import-Module Microsoft.Graph.Reports

class InteractiveSigninLogsCollector : BaseCollector {
    [string] $iniSection = "InteractiveSigninLogsCollector"

    InteractiveSigninLogsCollector() { }
    InteractiveSigninLogsCollector([hashtable] $globalConfig) {
        $this.globalConfig = $globalConfig
        $this.LoadConfig()
    }

    DoCollect() {
        $result = @{} 
        $result = Get-MgAuditLogSignIn # -Filter "signInEventTypes/any(t: t eq 'interactiveUser')"
        Write-Host "Collecting interactive sign-in logs..."

        $this.WriteResult($result)
    }
}

return @{
    klass = [InteractiveSigninLogsCollector]
    new = [InteractiveSigninLogsCollector]::new
}