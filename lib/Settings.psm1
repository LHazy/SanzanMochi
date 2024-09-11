class Settings {
    [string] $confFilePath
    [string] $outputPath
    [string] $outputFormat
    [object] $allSettings

    Settings([string] $confFilePath) {
        $this.confFilePath = $confFilePath
    }

    [void] LoadGlobalConf() {
        $this.allSettings = @{}
        Get-Content $this.confFilePath | %{$this.allSettings += ConvertFrom-StringData $_}

        $this.outputPath = $this.allSettings["outputPath"]

        $format = $this.allSettings["outputFormat"]
        if ($format -eq "JSON" -or $format -eq "CSV") {
            $this.outputFormat = $format
        } else {
            throw "outputFormat only accept ""JSON"" or ""CSV"""
        }
    }
}
