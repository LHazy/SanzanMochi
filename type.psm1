Class AbstructCollector {
    [hashtable] $globalConfig = @{}
    [hashtable] $controllerConfig = @{}
    [string[]] $requireScopes = @()
    [string] $iniSection = ""
    [boolean] $isEnabled = $false

    AbstructCollector() { }

    LoadConfig() {
        $this.controllerConfig = $this.globalConfig[$this.iniSection]
        $this.isEnabled = $this.controllerConfig["Enabled"]
        $this.requireScopes = $this.controllerConfig["RequireScopes"]
    }

    DoCollect() { }
}