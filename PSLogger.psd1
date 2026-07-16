@{
    RootModule           = "PSLogger.psm1"
    ModuleVersion        = "1.0.0"
    CompatiblePSEditions = @("Desktop", "Core")
    GUID                 = "31497280-6fb7-46ed-90fe-33206fad1ba3"
    Author               = "Lakshay Chauhan"
    Copyright            = "(c) 2026 Lakshay Chauhan. Licensed under the MIT License."
    Description          = "A lightweight PowerShell logging module with colored output, timestamps, debug logging, and helper functions for consistent console logging."
    PowerShellVersion    = "5.1"
    FunctionsToExport    = @(
        "Write-ErrorLog"
        "Write-InfoLog"
        "Write-WarnLog"
        "Write-DebugLog"
        "Write-SuccessLog"
        "Write-VisualSeparator"
        "Set-DebugLogging"
        "Set-TimestampLogging"
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
    PrivateData          = @{
        PSData = @{
            Tags          = @("Logging", "Console", "Utility", "PowerShell")
            ProjectUri    = "https://gitlab.com/ninthcircle/PSLogger"
            LicenseUri    = "https://opensource.org/licenses/MIT"
            RepositoryUri = "https://gitlab.com/ninthcircle/PSLogger"
            ReleaseNotes  = "Initial release."
        }
    }

}
