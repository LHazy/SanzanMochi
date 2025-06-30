# .ini file loader
function Load-Config {
    param (
        [string] $filePath = "config.ini"
    )

    if (-Not (Test-Path $filePath)) {
        Write-Error "Configuration file '$filePath' not found."
        return $null
    }

    $config = @{}
    $currentSection = ""

    Get-Content $filePath | ForEach-Object {
        $_ = $_.Trim()
        if ($_ -match '^\[(.+)\]$') {
            $currentSection = $matches[1]
            $config[$currentSection] = @{}
        } elseif ($_ -and $currentSection) {
            if ($_ -match '^(.*?)=(.*)$') {
                $key = $matches[1].Trim()

                $value = $matches[2].Trim()
                if ($key -eq "RequireScopes") {
                    $value = $value -split ', ' | ForEach-Object { $_.Trim() }
                } elseif ($key -eq "Enabled") {
                    $value = $value -eq "True"
                }

                $config[$currentSection][$key] = $value
            }
        }
    }

    return $config
}
