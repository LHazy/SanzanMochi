using module "../lib/Settings.psm1"
using module "../lib/BaseExtractor.psm1"

param(
    [string]$outputPath,
    [string]$outputFormat,
    [Settings]$settings
)

Import-Module Microsoft.Graph.Beta.Reports

class EntraAuditLogExtractor : BaseExtractor {
    EntraAuditLogExtractor([string] $outputPath, [string] $outputFormat, [Settings] $settings)
     : base($outputPath, $outputFormat, $settings) {
        $this.outputFilename =  "entraid_auditlog" + $this.GetFileExtension()
    }

    [void] Extract() {
        $this.results = Get-MgBetaAuditLogDirectoryAudit
    }
}

$extractor = [EntraAuditLogExtractor]::new($outputPath, $outputFormat, $settings)
$extractor.Extract()
$extractor.Save()