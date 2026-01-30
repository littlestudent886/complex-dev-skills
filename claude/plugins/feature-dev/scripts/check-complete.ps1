# Check if all phases in task_plan.md are complete.
# Exit 0 if complete, exit 1 if incomplete.

[CmdletBinding()]
param(
  [string]$PlanFile = "task_plan.md"
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

$rootDir = Get-GitRootOrPwd
$planPath = $PlanFile
if (-not [System.IO.Path]::IsPathRooted($planPath)) {
  $planPath = Join-Path $rootDir $planPath
}

if (-not (Test-Path $planPath)) {
  Write-Host "ERROR: $planPath not found"
  Write-Host "This workflow expects a persistent task_plan.md in the project root."
  exit 1
}

Write-Host "=== Feature-Dev Completion Check ==="

$content = Get-Content -Path $planPath -Raw -Encoding UTF8

$TOTAL = ([regex]::Matches($content, "^### Phase ", [System.Text.RegularExpressions.RegexOptions]::Multiline)).Count
$COMPLETE = ([regex]::Matches($content, "\*\*Status:\*\* complete")).Count
$IN_PROGRESS = ([regex]::Matches($content, "\*\*Status:\*\* in_progress")).Count
$PENDING = ([regex]::Matches($content, "\*\*Status:\*\* pending")).Count

Write-Host "Total phases:   $TOTAL"
Write-Host "Complete:       $COMPLETE"
Write-Host "In progress:    $IN_PROGRESS"
Write-Host "Pending:        $PENDING"
Write-Host ""

if ($TOTAL -gt 0 -and $COMPLETE -eq $TOTAL) {
  Write-Host "ALL PHASES COMPLETE"
  exit 0
}

Write-Host "TASK NOT COMPLETE"
exit 1

