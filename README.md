A lightweight PowerShell logging module with colored output, timestamps, debug logging,
and helper functions for consistent console logging.

## Features

- Colored log levels (ERROR, WARN, INFO, DEBUG, SUCCESS.)
- Optional timestamps on individual log messages.
- Global timestamp logging toggle.
- Configurable debug logging.
- Multi-line message formatting with automatic indentation.
- Visual separator utility.

## Installation

```powershell
Import-Module PSLogger
```

## Usage

```powershell
Import-Module PSLogger

Write-InfoLog -Message "Hello from PSLogger!" -Timestamp
```

Output:

```console
[2026-06-12 03:15:45] [INFO] Hello from PSLogger!
```

Enable debug logging:

```powershell
Set-DebugLogging -Enabled $true

Write-DebugLog -Message "Loaded configuration."
```

Enable timestamps globally:

```powershell
Set-TimestampLogging -Enabled $true

Write-InfoLog -Message "Application started."
Write-SuccessLog -Message "Initialization complete."
```

## Exported Commands

- `Write-ErrorLog`
- `Write-WarnLog`
- `Write-InfoLog`
- `Write-DebugLog`
- `Write-SuccessLog`
- `Write-VisualSeparator`
- `Set-DebugLogging`
- `Set-TimestampLogging`

## License

Licensed under the MIT License. See `LICENSE.txt` for details.
