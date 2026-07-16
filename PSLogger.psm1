<#
MIT License

Copyright (c) 2026 Lakshay Chauhan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Reference: <https://gitlab.com/ninthcircle/ps-logger/-/blob/master/PSLogger.psm1>
#>

enum LogLevel {
    ERROR
    WARN
    INFO
    DEBUG
    SUCCESS
}

$script:Colors = @{
    [LogLevel]::ERROR   = [ConsoleColor]::Red
    [LogLevel]::WARN    = [ConsoleColor]::Yellow
    [LogLevel]::INFO    = [ConsoleColor]::Blue
    [LogLevel]::DEBUG   = [ConsoleColor]::DarkGray
    [LogLevel]::SUCCESS = [ConsoleColor]::Green
}

$script:DebugEnabled = $false
$script:TimestampLoggingEnabled = $false

<#
.SYNOPSIS
Enables or disables debug logging.

.DESCRIPTION
Controls whether calls to Write-DebugLog produce output.

.PARAMETER Enabled
Specifies whether debug logging should be enabled.

.EXAMPLE
Set-DebugLogging -Enabled $true

.EXAMPLE
Set-DebugLogging -Enabled $false
#>
function Set-DebugLogging {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [bool]$Enabled
    )
    $script:DebugEnabled = $Enabled
}

<#
.SYNOPSIS
Enables or disables timestamps for all log messages.

.DESCRIPTION
Controls whether every log message includes a timestamp by default.

.PARAMETER Enabled
Specifies whether timestamp logging should be enabled.

.EXAMPLE
Set-TimestampLogging -Enabled $true
#>
function Set-TimestampLogging {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [bool]$Enabled
    )
    $script:TimestampLoggingEnabled = $Enabled
}

function Write-Log {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [LogLevel]$Level,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Message,
        [switch]$Timestamp
    )

    if (-not $Message -or $Message.Count -eq 0) { return }

    $IndentSize = 0
    if ($Timestamp -or $script:TimestampLoggingEnabled) {
        $CurrentTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $IndentSize += "[$CurrentTimestamp] ".Length
        Write-Host "[$CurrentTimestamp] " -NoNewline
    }

    Write-Host "[" -NoNewline
    $LevelText = $Level.ToString().ToUpperInvariant()
    Write-Host $LevelText -ForegroundColor $Colors[$Level] -NoNewline
    Write-Host "] $($Message[0])"

    $IndentSize += "[$LevelText] ".Length
    if ($Message.Count -le 1) { return }
    foreach ($Line in $Message[1..($Message.Count - 1)]) {
        Write-Host "$(' ' * $IndentSize)$Line"
    }
}

<#
.SYNOPSIS
Writes an error message.

.DESCRIPTION
Writes one or more error log lines using the ERROR log level.
Optionally throws a terminating error or exits the current PowerShell process.

.PARAMETER Message
The message to write. Multiple strings are written on separate lines.

.PARAMETER Exit
Exits the current PowerShell process with exit code 1 after writing the message.

.PARAMETER Throw
Throws a terminating exception after writing the message.

.PARAMETER Timestamp
Prefixes each message with the current timestamp.

.EXAMPLE
Write-ErrorLog -Message "Operation failed."

.EXAMPLE
Write-ErrorLog -Message @(
    "Operation failed.",
    "Unable to locate configuration file."
)

.EXAMPLE
Write-ErrorLog -Message "Fatal error." -Throw

.EXAMPLE
Write-ErrorLog -Message "Fatal error." -Exit
#>
function Write-ErrorLog {
    [CmdletBinding(DefaultParameterSetName = "None")]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Message,
        [Parameter(ParameterSetName = "Exit")]
        [switch]$Exit,
        [Parameter(ParameterSetName = "Throw")]
        [switch]$Throw,
        [switch]$Timestamp
    )
    Write-Log -Level ([LogLevel]::ERROR) -Message $Message -Timestamp:$Timestamp
    switch ($PSCmdlet.ParameterSetName) {
        "Throw" {
            throw ($Message -join [Environment]::NewLine)
        }
        "Exit" {
            exit 1
        }
    }
}

<#
.SYNOPSIS
Writes an informational message.

.DESCRIPTION
Writes one or more informational log lines.

.PARAMETER Message
The message to write.

.PARAMETER Timestamp
Prefixes the message with the current timestamp.

.EXAMPLE
Write-InfoLog -Message "Starting application."
#>
function Write-InfoLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Message,
        [switch]$Timestamp
    )
    Write-Log -Level ([LogLevel]::INFO) -Message $Message -Timestamp:$Timestamp
}

<#
.SYNOPSIS
Writes a warning message.

.DESCRIPTION
Writes one or more warning log lines.

.PARAMETER Message
The message to write.

.PARAMETER Timestamp
Prefixes the message with the current timestamp.

.EXAMPLE
Write-WarnLog -Message "Configuration file not found."
#>
function Write-WarnLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Message,
        [switch]$Timestamp
    )
    Write-Log -Level ([LogLevel]::WARN) -Message $Message -Timestamp:$Timestamp
}

<#
.SYNOPSIS
Writes a debug message.

.DESCRIPTION
Writes one or more debug log lines when debug logging is enabled.

.PARAMETER Message
The message to write.

.PARAMETER Timestamp
Prefixes the message with the current timestamp.

.EXAMPLE
Set-DebugLogging -Enabled $true
Write-DebugLog -Message "Configuration loaded."
#>
function Write-DebugLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Message,
        [switch]$Timestamp
    )
    if (-not $script:DebugEnabled) { return }
    Write-Log -Level ([LogLevel]::DEBUG) -Message $Message -Timestamp:$Timestamp
}

<#
.SYNOPSIS
Writes a success message.

.DESCRIPTION
Writes one or more success log lines.

.PARAMETER Message
The message to write.

.PARAMETER Timestamp
Prefixes the message with the current timestamp.

.EXAMPLE
Write-SuccessLog -Message "Operation completed successfully."
#>
function Write-SuccessLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Message,
        [switch]$Timestamp
    )
    Write-Log -Level ([LogLevel]::SUCCESS) -Message $Message -Timestamp:$Timestamp
}

<#
.SYNOPSIS
Writes a visual separator.

.DESCRIPTION
Writes a horizontal separator line using the specified log level.

.PARAMETER Level
The log level used to color the separator.
Defaults to INFO.

.PARAMETER Timestamp
Prefixes the separator with the current timestamp.

.EXAMPLE
Write-VisualSeparator

.EXAMPLE
Write-VisualSeparator -Level SUCCESS

.EXAMPLE
Write-VisualSeparator -Timestamp
#>
function Write-VisualSeparator {
    [CmdletBinding()]
    param(
        [LogLevel]$Level = ([LogLevel]::INFO),
        [switch]$Timestamp
    )
    Write-Log -Level $Level -Message @("-" * 72) -Timestamp:$Timestamp
}

Export-ModuleMember -Function @(
    "Write-ErrorLog",
    "Write-InfoLog",
    "Write-WarnLog",
    "Write-DebugLog",
    "Write-SuccessLog",
    "Set-DebugLogging",
    "Set-TimestampLogging",
    "Write-VisualSeparator"
)
