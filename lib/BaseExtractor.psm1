using module "./Settings.psm1"

class BaseExtractor {
    [object[]] $results
    [string] $outputPath
    [string] $outputFilename
    [string] $confPrefix
    [Settings] $settings
    [object] $extractorConf
    [string] $outputFormat
    
    BaseExtractor([string] $outputPath, [string] $outputFormat, [Settings] $settings) {
        $this.results = @()
        $this.confPrefix = $this.GetExtractorIniSectionName() + "_"
        $this.outputPath = $outputPath
        $this.outputFormat = $outputFormat
        $this.settings = $settings
        $this.CollectExtractorConf()
    }

    [string] GetFileExtension() {
        if ($this.outputFormat -eq "JSON") {
            return '.json'
        } elseif ($this.outputFormat -eq "CSV") {
            return '.csv'
        } else {
            return ''
        }
    }

    [string] GetExtractorIniSectionName() {
        return $this.GetType().Name
    }

    [void] CollectExtractorConf() {
        $this.extractorConf = @{}

        foreach ($key in $this.settings.allSettings.keys) {
            if ($key -like "$($this.confPrefix)*") {
                $this.extractorConf[$key] = $this.settings.allSettings[$key]
            }
        }
    }

    [void] Extract() { }

    [void] Save() {
        $filepath = Join-Path $this.outputPath $this.outputFilename
        switch ($this.outputFormat) {
            "JSON"{ 
                ConvertTo-Json $this.results -Depth 100 | Out-File -FilePath $filepath
            }
            "CSV"{
                ConvertTo-Csv $this.results | Out-File -FilePath $filepath
            }
            Default {}
        }
    }

    [object[]] GetResults() {
        return $this.results
    }
}
