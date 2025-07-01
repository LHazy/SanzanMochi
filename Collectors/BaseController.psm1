Class BaseCollector {
    [hashtable] $globalConfig = @{}
    [hashtable] $controllerConfig = @{}
    [string] $iniSection = ""
    [boolean] $isEnabled = $false
    [string[]] $requireScopes = @()
    [string] $outputFileName = ""

    BaseCollector() { }

    LoadConfig() {
        $this.controllerConfig = $this.globalConfig[$this.iniSection]
        $this.isEnabled = $this.controllerConfig["Enabled"]
        $this.requireScopes = $this.controllerConfig["RequireScopes"]

        if (-not $this.controllerConfig.ContainsKey("OutputFileName")) {
            $this.outputFileName = "$($this.iniSection).json"
        } else {
            $this.outputFileName = $this.controllerConfig["OutputFileName"]
        }
    }

    WriteResult($result) {
        $outputFolder = $this.globalConfig["OutputFolderPath"]
        $outputFile = Join-Path -Path $outputFolder -ChildPath $this.outputFileName
        if (-not (Test-Path -Path $outputFolder)) {
            New-Item -Path $outputFolder -ItemType Directory | Out-Null
        }
        $result | ConvertTo-Json -Depth 10 | Out-File -FilePath $outputFile -Encoding utf8 -Force
    }
}