<#
.SYNOPSIS
    Deterministic subtask verification script for Phase 3 (Layer 05).
.DESCRIPTION
    Runs compilation/tests, checks git diff line count, and outputs compact JSON
    to prevent context bloating and eliminate self-certified LLM checks.
.PARAMETER ServicePath
    Relative or absolute path to the service (e.g. 'src/customer/customer-service').
.PARAMETER BuildCommand
    Custom build command (e.g. 'mvn -q -DskipTests package'). Auto-detected if omitted.
.PARAMETER SkipBuild
    Only check git diff and context health without running build.
.PARAMETER MaxDiffLines
    Threshold for suggesting a new session (default 200 lines per AGENTS.md).
#>
[CmdletBinding()]
param(
    [string]$ServicePath = "",
    [string]$BuildCommand = "",
    [switch]$SkipBuild,
    [int]$MaxDiffLines = 200
)

$ErrorActionPreference = "Stop"

function Get-GitDiffStats {
    param([string]$targetDir)
    $workingDir = if ($targetDir -and (Test-Path $targetDir)) { $targetDir } else { (Get-Location).Path }
    
    $filesChanged = 0
    $totalDiffLines = 0
    
    try {
        # Check diff in current repo/submodule
        $stat = git -C $workingDir diff --shortstat 2>$null
        if ($stat -match '(\d+)\s+file[s]?\s+changed') {
            $filesChanged = [int]$Matches[1]
        }
        $insertions = 0
        $deletions = 0
        if ($stat -match '(\d+)\s+insertion') { $insertions = [int]$Matches[1] }
        if ($stat -match '(\d+)\s+deletion') { $deletions = [int]$Matches[1] }
        $totalDiffLines = $insertions + $deletions
    } catch {
        # Git error or not a git repo
    }
    
    return @{
        FilesChanged = $filesChanged
        DiffLines = $totalDiffLines
    }
}

$targetPath = $ServicePath
if (-not $targetPath -and (Test-Path "src")) {
    # If not provided, search for modified submodule or use current
    $status = git status --porcelain 2>$null
    if ($status -match 'src/([a-zA-Z0-9_\-]+/[a-zA-Z0-9_\-]+)') {
        $targetPath = "src/$($Matches[1])"
    }
}

$diffStats = Get-GitDiffStats -targetDir $targetPath
$diffLines = $diffStats.DiffLines
$filesChanged = $diffStats.FilesChanged

$suggestNewSession = ($diffLines -gt $MaxDiffLines)
$suggestionReason = ""
if ($suggestNewSession) {
    $suggestionReason = "Diff contains $diffLines lines (> $MaxDiffLines limit). Suggest opening a fresh session for next subtask."
}

$buildStatus = "SKIPPED"
$exitCode = 0
$errorSnippet = ""
$executedCommand = ""
$durationSec = 0

if (-not $SkipBuild) {
    $actualDir = if ($targetPath -and (Test-Path $targetPath)) { (Resolve-Path $targetPath).Path } else { (Get-Location).Path }
    
    if (-not $BuildCommand) {
        if (Test-Path (Join-Path $actualDir "pom.xml")) {
            $BuildCommand = "mvn -q -DskipTests package"
        } elseif (Test-Path (Join-Path $actualDir "package.json")) {
            $BuildCommand = "npm test"
        }
    }
    
    if ($BuildCommand) {
        $executedCommand = $BuildCommand
        $startTime = Get-Date
        
        $prevPwd = (Get-Location).Path
        try {
            Set-Location $actualDir
            $buildOutput = Invoke-Expression "$BuildCommand 2>&1"
            $exitCode = $LASTEXITCODE
            if ($null -eq $exitCode) { $exitCode = 0 }
        } catch {
            $exitCode = 1
            $buildOutput = $_.Exception.Message
        } finally {
            Set-Location $prevPwd
        }
        
        $durationSec = [math]::Round(((Get-Date) - $startTime).TotalSeconds, 2)
        
        if ($exitCode -eq 0) {
            $buildStatus = "SUCCESS"
        } else {
            $buildStatus = "FAILED"
            # Extract last 10 lines or lines matching ERROR/FATAL
            $lines = ($buildOutput -split "\r?\n")
            $errorLines = $lines | Where-Object { $_ -match '(?i)ERROR|FATAL|FAILED|Exception|cannot find' } | Select-Object -First 8
            if (-not $errorLines) {
                $errorLines = $lines | Select-Object -Last 8
            }
            $errorSnippet = ($errorLines -join "`n").Trim()
        }
    } else {
        $buildStatus = "NO_BUILD_FILE_FOUND"
    }
}

$result = [PSCustomObject]@{
    status = $buildStatus
    exit_code = $exitCode
    service = $targetPath
    build_command = $executedCommand
    duration_sec = $durationSec
    diff_lines = $diffLines
    files_changed = $filesChanged
    suggest_new_session = $suggestNewSession
    suggestion_message = $suggestionReason
    error_snippet = $errorSnippet
    timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
}

# Output compact JSON for model consumption
$result | ConvertTo-Json -Compress

