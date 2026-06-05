# Claude Code UserPromptSubmit hook — injecte l'état de CETTE session, sweep orphelins >24h.
$ErrorActionPreference = 'SilentlyContinue'
$dir = 'system/.session-state'
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
Get-ChildItem -Path $dir -Filter '*.md' -File |
  Where-Object { $_.LastWriteTime -lt (Get-Date).AddHours(-24) } | Remove-Item -Force
$raw = [Console]::In.ReadToEnd()
$sid = ''
try { $sid = ($raw | ConvertFrom-Json).session_id } catch {}
if (-not $sid) { $sid = 'unknown' }
$path = Join-Path $dir "$sid.md"
Write-Output "SESSION_ID: $sid"
Write-Output "SESSION_STATE_FILE: $path"
if (Test-Path $path) { Get-Content $path -Encoding UTF8 -Raw }
else { Write-Output '(no active session for this id - write your state to SESSION_STATE_FILE once session-start validates a task)' }
