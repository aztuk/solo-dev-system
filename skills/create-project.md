# Skill — create-project

## Déclencheur

Demande explicite de créer un nouveau projet basé sur AgenticSystem.

---

## Étape 1 — Collecter les informations

Demander à l'humain :
1. **Nom du projet** (slug kebab-case, ex : `mon-app`)
2. **Chemin parent** où créer le dossier (ex : `C:\Users\quent\Documents\Projets`)

Attendre la réponse avant de continuer.

---

## Étape 2 — Créer la structure

```
<chemin-parent>/<nom-projet>/
  AgenticSystem/       ← submodule (framework : skills, system/, AGENTS.md)
  tasks/
  system/              ← fichiers projet uniquement (memory, tokens)
  design-system/
  .claude/rules/
```

```bash
mkdir <chemin>/<nom> && cd <chemin>/<nom> && git init
git submodule add https://github.com/aztuk/solo-dev-system.git AgenticSystem
mkdir tasks system design-system && mkdir -p .claude/rules
```

---

## Étape 3 — Copier les templates

Tous les fichiers projet sont copiés depuis `AgenticSystem/boilerplate/`. Ne pas générer de contenu inline.

| Source (AgenticSystem/boilerplate/) | Destination (racine projet) |
|---|---|
| `CLAUDE.md` | `CLAUDE.md` |
| `.gitignore` | `.gitignore` |
| `TODO.md` | `TODO.md` |
| `roadmap.md` | `roadmap.md` |
| `system/memory.md` | `system/memory.md` |
| `system/tokens.md` | `system/tokens.md` |
| `design-system/component-catalog.md` | `design-system/component-catalog.md` |
| `design-system/flows-catalog.md` | `design-system/flows-catalog.md` |

**Fichiers système NON copiés** : `governance.md`, `access-control.md`, `agent-patterns.md` restent dans `AgenticSystem/system/` et sont lus depuis le submodule par tous les agents.

---

## Étape 4 — Commit initial

```bash
git add . && git commit -m "chore: init projet avec submodule AgenticSystem"
```

---

## Étape 5 — Vérification

```
Projet <nom> créé dans <chemin>.

  AgenticSystem/              → submodule (framework)
  tasks/                      → artefacts de tâches
  system/memory.md            → décisions projet
  system/tokens.md            → design tokens projet
  design-system/              → component-catalog, flows-catalog
  CLAUDE.md  TODO.md  roadmap.md  .gitignore

Fichiers système lus depuis AgenticSystem/system/ :
  governance.md  access-control.md  agent-patterns.md

Prochaine étape : ouvrir <chemin>/<nom> dans Claude Code.
```

Ne pas proposer d'actions supplémentaires. Attendre.
