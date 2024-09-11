using module "./lib/Settings.psm1"

function Collect-EnabledExtractor {
    $enabledExtractors = @()

    $extractors = Get-ChildItem ./extractors/ -Filter "*Extractor.ps1"

    foreach ($extractor in $extractors) {
        $extractorName = $extractor.BaseName
        $enabled = $settings.allSettings["$($extractorName)_enable"]

        if ($enabled -eq "true") {
            $enabledExtractors += $extractor.Name
        }
    }

    return $enabledExtractors
}


$settings = [Settings]::new("conf.ini")
$settings.LoadGlobalConf()

$outputPath = $settings.outputPath
$outputFormat = $settings.outputFormat

if (-not (Test-Path $outputPath)) {
    New-Item $outputPath -ItemType Directory
}

Connect-MgGraph -Scopes $settings.allSettings['scopes'] -NoWelcome
& ./extractors/EntraAuditLogExtractor.ps1 -outputPath $outputPath -outputFormat $outputFormat -settings $settings
