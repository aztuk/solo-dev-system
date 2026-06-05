# Codex command hook (SessionStart / Stop) — nettoyage seul (pas d'injection possible chez Codex).
$ErrorActionPreference = 'SilentlyContinue'
$dir = 'system/.session-state'
if (-not (Test-Path $dir)) { return }
Get-ChildItem -Path $dir -Filter '*.md' -File |
  Where-Object { $_.LastWriteTime -lt (Get-Date).AddHours(-24) } | Remove-Item -Force
