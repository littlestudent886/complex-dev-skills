# Initialize `complex-feature-dev` planning files in your project.
# - Default: create files in git repo root (if inside a git repo), otherwise current directory.
# - This is the Windows/PowerShell counterpart to `init-session.sh`.

[CmdletBinding()]
param(
  [string]$Dir,
  [switch]$Here,
  [switch]$Agents,
  [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-GitRootOrPwd {
  $git = Get-Command git -ErrorAction SilentlyContinue
  if ($null -eq $git) {
    return (Get-Location).Path
  }

  try {
    $root = (& git rev-parse --show-toplevel 2>$null).Trim()
    if ($root) { return $root }
  } catch {
    # ignore
  }

  return (Get-Location).Path
}

$scriptDir = $PSScriptRoot
$skillDir = (Resolve-Path (Join-Path $scriptDir "..")).Path
$templatesDir = Join-Path $skillDir "assets/templates"

if (-not (Test-Path $templatesDir)) {
  throw "templates directory not found: $templatesDir"
}

if ($Here) {
  $destDir = (Get-Location).Path
} elseif ($Dir) {
  $destDir = (Resolve-Path $Dir).Path
} else {
  $destDir = Get-GitRootOrPwd
}

if (-not (Test-Path $destDir)) {
  throw "destination directory not found: $destDir"
}

function Copy-TemplateFile {
  param([Parameter(Mandatory = $true)][string]$FileName)

  $src = Join-Path $templatesDir $FileName
  if (-not (Test-Path $src)) {
    throw "missing template: $src"
  }

  $dst = Join-Path $destDir $FileName
  if ((Test-Path $dst) -and (-not $Force)) {
    Write-Host "$FileName already exists in $destDir, skipping"
    return
  }

  Copy-Item -Path $src -Destination $dst -Force
  Write-Host "Created $dst"
}

Copy-TemplateFile -FileName "task_plan.md"
Copy-TemplateFile -FileName "findings.md"
Copy-TemplateFile -FileName "progress.md"

if ($Agents) {
  Copy-TemplateFile -FileName "AGENTS.md"
}

# Fill in date placeholder (if present)
$date = Get-Date -Format "yyyy-MM-dd"
$progressPath = Join-Path $destDir "progress.md"
if (Test-Path $progressPath) {
  $content = Get-Content -Path $progressPath -Raw -Encoding UTF8
  $content = $content -replace "\{\{DATE\}\}", $date
  Set-Content -Path $progressPath -Value $content -Encoding UTF8
}

Write-Host ""
Write-Host "Planning files ready in: $destDir"
Write-Host "  - task_plan.md"
Write-Host "  - findings.md"
Write-Host "  - progress.md"
