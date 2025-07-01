Class BaseCollector {
    [hashtable] $globalConfig = @{}
    [hashtable] $controllerConfig = @{}
    [string[]] $requireScopes = @()
    [string] $iniSection = ""
    [boolean] $isEnabled = $false

    BaseCollector() { }

    LoadConfig() {
        $this.controllerConfig = $this.globalConfig[$this.iniSection]
        $this.isEnabled = $this.controllerConfig["Enabled"]
        $this.requireScopes = $this.controllerConfig["RequireScopes"]
    }

    DoCollect() { }
}