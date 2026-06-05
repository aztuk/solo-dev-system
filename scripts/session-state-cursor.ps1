# Cursor sessionStart hook — injecte l'état de CETTE session via additional_context, sweep orphelins >24h.
$ErrorActionPreference = 'SilentlyContinue'
$dir = 'system/.session-state'
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
Get-ChildItem -Path $dir -Filter '*.md' -File |
  Where-Object { $_.LastWriteTime -lt (Get-Date).AddHours(-24) } | Remove-Item -Force
$raw = [Console]::In.ReadToEnd()
$sid = ''
try { $sid = ($raw | ConvertFrom-Json).conversation_id } catch {}
if (-not $sid) { $sid = [guid]::NewGuid().ToString() }
$path = "$dir/$sid.md"
$state = if (Test-Path $path) { Get-Content $path -Encoding UTF8 -Raw } else { '(no active session for this id)' }
$ctx = "SESSION_ID: $sid`nSESSION_STATE_FILE: $path`n$state"
@{ additional_context = $ctx } | ConvertTo-Json -Compress
