# migrate-to-project.ps1
# Applies AgenticSystem updates to an existing project created from the template.
#
# Usage:
#   .\scripts\migrate-to-project.ps1 -TargetPath "C:\path\to\your\project"
#
# Safe to run multiple times -- each step checks before applying.

param(
    [Parameter(Mandatory=$true)]
    [string]$TargetPath
)

$SourcePath = Split-Path $PSScriptRoot -Parent

if (-not (Test-Path $TargetPath)) {
    Write-Error "Target path not found: $TargetPath"
    exit 1
}
if (-not (Test-Path (Join-Path $TargetPath "AGENTS.md"))) {
    Write-Error "Target does not look like a valid AgenticSystem project (no AGENTS.md)."
    exit 1
}

$applied = 0
$skipped = 0
$warned  = 0

function Ok($file, $msg)   { Write-Host "  [+] $file -- $msg"; $script:applied++ }
function Skip($file, $msg) { Write-Host "  [~] $file -- $msg"; $script:skipped++ }
function Warn($file, $msg) { Write-Host "  [!] $file -- $msg"; $script:warned++  }

Write-Host ""
Write-Host "Migrating AgenticSystem updates"
Write-Host "Target : $TargetPath"
Write-Host "Source : $SourcePath"
Write-Host "-------------------------------------------------"
Write-Host ""

# -- 1. system/session-state-claude.md (new file) ------------------------------

$dest = Join-Path $TargetPath "system\session-state-claude.md"
if (Test-Path $dest) {
    Skip "system/session-state-claude.md" "already exists"
} else {
    $lines = @(
        "# Session state -- Claude Code",
        "",
        "> Injected automatically before each message via UserPromptSubmit hook.",
        "> Updated by Claude Code at each phase transition.",
        "> Do not edit manually.",
        "",
        "---",
        "",
        "**Phase**    : - (no active session)",
        "**Task**     : -",
        "**Category** : -",
        "**Priority** : -",
        "",
        "**Active constraints** :",
        "- None",
        "",
        "**Challenge conclusions** : -",
        "",
        "**Pending decisions** : None"
    )
    $lines -join "`n" | Set-Content $dest -Encoding UTF8
    Ok "system/session-state-claude.md" "created"
}

# -- 2. skills/product-challenge.md (new file) ---------------------------------

$src  = Join-Path $SourcePath "skills\product-challenge.md"
$dest = Join-Path $TargetPath "skills\product-challenge.md"
if (Test-Path $dest) {
    Skip "skills/product-challenge.md" "already exists"
} elseif (-not (Test-Path $src)) {
    Warn "skills/product-challenge.md" "source file not found in AgenticSystem repo"
} else {
    Copy-Item $src $dest
    Ok "skills/product-challenge.md" "copied"
}

# -- 3. skills/session-start.md -- add Step 6 ----------------------------------

$path = Join-Path $TargetPath "skills\session-start.md"
if (-not (Test-Path $path)) {
    Warn "skills/session-start.md" "not found in target -- skipped"
} else {
    $content = Get-Content $path -Raw -Encoding UTF8
    if ($content -match "Etape 6") {
        Skip "skills/session-start.md" "step 6 already present"
    } else {
        $step6 = @"


---

### Etape 6 -- Initialiser system/session-state-claude.md

Une fois la tache validee par l'humain, ecrire dans ``system/session-state-claude.md`` avec le contenu initial (phase 1, tache, categorie, priorite, contraintes actives). Ce fichier est mis a jour a chaque transition de phase dans AGENTS.md.
"@
        Add-Content $path $step6 -Encoding UTF8
        Ok "skills/session-start.md" "step 6 added"
    }
}

# -- 4. AGENTS.md -- targeted patches ------------------------------------------

$path    = Join-Path $TargetPath "AGENTS.md"
$content = Get-Content $path -Raw -Encoding UTF8
$changed = $false

# 4a -- Skills table: add product-challenge entry
if ($content -match "product-challenge") {
    Skip "AGENTS.md" "product-challenge already in skills table"
} else {
    $anchor = "session-start.md``"
    $idx = $content.IndexOf($anchor)
    if ($idx -ge 0) {
        $lineEnd = $content.IndexOf("`n", $idx)
        if ($lineEnd -lt 0) { $lineEnd = $content.Length }
        $newLine = "`n| ``skills/product-challenge.md`` | Apres classification, pour toute tache M+ (Dev, Design, Produit) |"
        $content = $content.Insert($lineEnd, $newLine)
        $changed = $true
        Ok "AGENTS.md" "product-challenge added to skills table"
    } else {
        Warn "AGENTS.md" "skills table anchor not found -- product-challenge not added"
    }
}

# 4b -- Routing table: add Phase 2b references
if ($content -match "Phase 2b") {
    Skip "AGENTS.md" "Phase 2b already in routing/sections"
} else {
    $content = $content.Replace(
        "Phases 3",
        "Phase 2b (si M+) -> Phases 3"
    ).Replace(
        "Ouvrir Figma.",
        "Phase 2b (si M+) -> Figma."
    ).Replace(
        "Phase 3 (si M+) -> implementation directe",
        "Phase 2b (si M+) -> Phase 3 -> implementation directe"
    ).Replace(
        "Phase 3 (si M+) -> modification schema",
        "Phase 2b (si M+) -> Phase 3 -> modification schema"
    )

    # Also try with accented variants
    $content = $content.Replace(
        "Pr" + [char]0xe9 + "senter les options",
        "Phase 2b (si M+) -> Pr" + [char]0xe9 + "senter les options"
    )

    $changed = $true
    Ok "AGENTS.md" "routing table updated with Phase 2b"

    # 4c -- Insert Phase 2b section before Phase 3
    $phase3anchor = "### PHASE 3"
    $idx = $content.IndexOf($phase3anchor)
    if ($idx -ge 0) {
        $phase2bBlock = @"

### PHASE 2b -- Product challenge (M+ uniquement)

Executer ``skills/product-challenge.md``.

Ce skill :
1. Analyse la tache et identifie hypotheses implicites, edge cases et decisions de design ouvertes
2. Poste toutes les questions en un seul message -- attend la reponse humaine
3. Ecrit les conclusions dans ``system/session-state-claude.md`` avant de continuer

**L'agent ne passe pas en Phase 3 tant que l'humain n'a pas repondu au challenge.**

---

"@
        $content = $content.Insert($idx, $phase2bBlock)
        Ok "AGENTS.md" "Phase 2b section inserted"
    } else {
        Warn "AGENTS.md" "Phase 3 anchor not found -- Phase 2b section not inserted"
    }
}

# 4d -- Phase state updates
if ($content -match "session-state-claude") {
    Skip "AGENTS.md" "phase state updates already present"
} else {
    # Phase 4 anchor
    $anchor = "Avant d'impl"
    $idx = $content.IndexOf($anchor)
    if ($idx -ge 0) {
        $insert = "Mettre a jour ``system/session-state-claude.md`` : Phase -> 4.`n`n"
        $content = $content.Insert($idx, $insert)
    }
    # Phase 5 anchor
    $anchor = "menter selon le plan valid"
    $idx = $content.IndexOf("Impl" + [char]0xe9 + $anchor)
    if ($idx -lt 0) { $idx = $content.IndexOf("Impl" + $anchor) }
    if ($idx -ge 0) {
        $insert = "Mettre a jour ``system/session-state-claude.md`` : Phase -> 5.`n`n"
        $content = $content.Insert($idx, $insert)
    }
    # Phase 6 anchor
    $anchor = "skills/compliance.md``."
    $idx = $content.IndexOf($anchor)
    if ($idx -ge 0) {
        # Insert before the line containing this anchor
        $lineStart = $content.LastIndexOf("`n", $idx) + 1
        $insert = "Mettre a jour ``system/session-state-claude.md`` : Phase -> 6.`n`n"
        $content = $content.Insert($lineStart, $insert)
    }
    # Phase 7 clôture: add reset of session-state
    $anchor = "Signaler "
    $idx = $content.IndexOf($anchor)
    if ($idx -ge 0) {
        $lineStart = $content.LastIndexOf("`n", $idx) + 1
        $insert = "4. R" + [char]0xe9 + "initialiser ``system/session-state-claude.md`` " + [char]0xe0 + " l'" + [char]0xe9 + "tat par d" + [char]0xe9 + "faut (aucune session active)`n"
        $content = $content.Insert($lineStart, $insert)
    }
    $changed = $true
    Ok "AGENTS.md" "phase state updates added"
}

if ($changed) {
    Set-Content $path $content -Encoding UTF8 -NoNewline
}

# -- 5. system/access-control.md -----------------------------------------------

$path = Join-Path $TargetPath "system\access-control.md"
if (-not (Test-Path $path)) {
    Warn "system/access-control.md" "not found -- skipped"
} else {
    $content = Get-Content $path -Raw -Encoding UTF8
    if ($content -match "session-state-claude") {
        Skip "system/access-control.md" "entry already present"
    } else {
        $anchor = "``skills/*.md``"
        $idx = $content.IndexOf($anchor)
        if ($idx -ge 0) {
            $lineStart = $content.LastIndexOf("`n", $idx) + 1
            $newLine = "| ``system/session-state-claude.md`` | Tout agent | Claude Code en session | Transition de phase ou fin de product-challenge |`n"
            $content = $content.Insert($lineStart, $newLine)
            Set-Content $path $content -Encoding UTF8 -NoNewline
            Ok "system/access-control.md" "session-state-claude entry added"
        } else {
            Warn "system/access-control.md" "anchor not found -- entry not added"
        }
    }
}

# -- 6. .claude/settings.json -- add UserPromptSubmit hook ---------------------

$settingsPath = Join-Path $TargetPath ".claude\settings.json"
$hookCommand  = "powershell -NoProfile -Command `"if (Test-Path 'system/session-state-claude.md') { Get-Content 'system/session-state-claude.md' -Encoding UTF8 -Raw }`""

if (-not (Test-Path $settingsPath)) {
    $dir = Split-Path $settingsPath
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory $dir | Out-Null }
    $bare = @{
        permissions = @{ allow = @() }
        hooks = @{
            UserPromptSubmit = @(
                @{ matcher = ""; hooks = @( @{ type = "command"; command = $hookCommand } ) }
            )
        }
    }
    $bare | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8
    Ok ".claude/settings.json" "created with hook"
} else {
    $raw = Get-Content $settingsPath -Raw -Encoding UTF8
    if ($raw -match "session-state-claude") {
        Skip ".claude/settings.json" "hook already present"
    } else {
        try {
            $settings = $raw | ConvertFrom-Json
            $hookEntry = [PSCustomObject]@{
                matcher = ""
                hooks   = @( [PSCustomObject]@{ type = "command"; command = $hookCommand } )
            }
            if (-not ($settings.PSObject.Properties.Name -contains 'hooks')) {
                $settings | Add-Member -MemberType NoteProperty -Name 'hooks' -Value (
                    [PSCustomObject]@{ UserPromptSubmit = @($hookEntry) }
                )
            } elseif (-not ($settings.hooks.PSObject.Properties.Name -contains 'UserPromptSubmit')) {
                $settings.hooks | Add-Member -MemberType NoteProperty -Name 'UserPromptSubmit' -Value @($hookEntry)
            } else {
                $settings.hooks.UserPromptSubmit = @($settings.hooks.UserPromptSubmit) + $hookEntry
            }
            $settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8
            Ok ".claude/settings.json" "hook added"
        } catch {
            Warn ".claude/settings.json" "JSON parse error -- add hook manually"
        }
    }
}

# -- Summary -------------------------------------------------------------------

Write-Host ""
Write-Host "-------------------------------------------------"
Write-Host "  $applied applied   $skipped skipped   $warned warnings"
Write-Host ""
if ($warned -gt 0) {
    Write-Host "  Review warnings above before using the project."
    Write-Host ""
}
