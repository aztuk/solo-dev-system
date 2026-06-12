# Agentic System

Systeme d'orchestration pour travailler avec plusieurs agents IA (Claude Code, Codex, Cursor) dans un meme projet. Le depot fournit un protocole commun, des skills atomiques, un backlog structure, un controle d'acces fichier par fichier et une memoire projet partagee.

Le principe central est simple : l'humain decide, `AGENTS.md` orchestre, les skills executent.

---

## Architecture

```text
Niveau 0 : Humain
Niveau 1 : AGENTS.md  <- orchestrateur unique
Niveau 2 : Skills     <- actions atomiques
```

- `AGENTS.md` est le protocole commun lu par tous les agents.
- Les adapters (`CLAUDE.md`, `.cursor/rules/`, configuration Codex) ajoutent uniquement les consignes propres a chaque outil.
- Les skills dans `skills/` sont des feuilles : ils ne s'appellent jamais entre eux.
- Les decisions durables vivent dans `system/` : gouvernance, access control, memoire, tokens.
- Les taches passent par `TODO.md`, `roadmap.md` et les artefacts `tasks/<slug>/`.

---

## Cycle de session

Au premier message, l'agent execute `skills/session-start.md` une seule fois.

1. Il cree un etat de session ephemere dans `system/.session-state/<id>.md`.
2. Il charge le cache minimal de gouvernance et d'access-control.
3. En mode consultation, il repond sans charger la roadmap.
4. En mode implementation, il travaille sur une tache existante ou attend une validation humaine pour une exception hors roadmap.

Les fichiers de session sont ignores par Git et nettoyes automatiquement quand ils ont plus de 24h.

---

## Cycle de tache

Les nouvelles demandes entrent d'abord dans `TODO.md`. La synchronisation vers `roadmap.md` se fait via `skills/sync-todo.md`, notamment depuis `skills/next-task.md` ou en fin de session.

Une tache peut suivre le pipeline :

```text
Exploration -> Planification -> Implementation -> Review
```

| Phase | Skill |
|---|---|
| Choisir la prochaine tache | `skills/next-task.md` |
| Exploration | `skills/phase-exploration.md` |
| Planification | `skills/phase-plan.md` |
| Implementation | `skills/phase-implementation.md` |
| Review | `skills/phase-review.md` |

Pour les taches M+, `skills/product-challenge.md` intervient avant la planification. Pour les changements UI ou design system, `skills/design-audit.md` verifie les composants et tokens avant implementation.

---

## Git et cloture

La cloture passe par `skills/phase-review.md`, puis `skills/commit-protocol.md`.

Avant commit :

- les tests unitaires sont executes si du code executable a change ;
- `skills/compliance.md` doit passer ;
- l'humain valide les tests manuels si necessaire ;
- seuls les fichiers du perimetre de la tache sont stages.

Apres commit, le protocole peut mettre a jour la roadmap, synchroniser `TODO.md`, evaluer `system/memory.md`, puis supprimer l'etat de session.

---

## Structure du depot

```text
AGENTS.md                         Protocole commun et orchestrateur
CLAUDE.md                         Adapter Claude Code
.cursor/rules/protocol.mdc        Adapter Cursor
.claude/rules/                    Regles Claude Code par famille de fichiers
TODO.md                           Entrees libres de l'humain
roadmap.md                        Backlog structure gere par les agents

system/
  governance.md                   Regles non negociables du projet
  access-control.md               Droits de lecture/ecriture par fichier
  memory.md                       Decisions et trade-offs durables
  tokens.md                       Tokens design
  agent-patterns.md               Patterns de delegation et routing modele
  .session-state/                 Etats de session ephemeres ignores par Git

skills/
  session-start.md                Initialisation de session
  next-task.md                    Selection de tache
  sync-todo.md                    Synchronisation TODO -> roadmap
  phase-exploration.md            Exploration structuree
  phase-plan.md                   Planification
  phase-implementation.md         Implementation
  phase-review.md                 Review, tests, compliance, commit
  implementation-guardrails.md    Verifications avant code
  product-challenge.md            Challenge produit pour taches M+
  design-audit.md                 Audit composants et tokens
  unit-tests.md                   Verification tests apres implementation
  compliance.md                   Audit avant commit
  figma-sync.md                   Sync Figma vers tokens/design-system
  commit-protocol.md              Commit, sync finale, cloture
  update-system.md                Mise a jour des fichiers systeme
  create-skill.md                 Creation de nouveau skill

tasks/
  <slug>/
    exploration.md
    plan.md
    review.md

design-system/
  component-catalog.md
  flows-catalog.md
  components/
  flows/

scripts/
  session-state-hook.ps1
  session-state-cursor.ps1
  session-state-sweep.ps1
  migrate-to-project.ps1
```

---

## Regles fortes

- L'humain garde la decision sur le produit, l'architecture et la gouvernance.
- Un agent verifie `system/access-control.md` avant toute ecriture.
- Les valeurs visuelles ne sont jamais hardcodees : elles viennent des tokens.
- Aucun composant n'est cree sans audit design applicable.
- Aucun commit ne part sans compliance validee.
- Les skills ne s'appellent jamais entre eux.

---

## Creer un nouveau projet

AgenticSystem s'utilise comme submodule Git dans vos projets. Le skill `create-project` orchestre la creation complete.

### Via Claude Code (recommande)

Dans une session Claude Code pointant sur ce depot, taper :

```
cree un projet
```

L'agent demande le nom (slug kebab-case) et le chemin parent, puis :

1. Initialise un depot Git vide dans `<chemin>/<nom>/`
2. Ajoute AgenticSystem comme submodule dans `AgenticSystem/`
3. Cree les dossiers `tasks/`, `system/`, `design-system/`, `.claude/rules/`
4. Copie les templates depuis `AgenticSystem/boilerplate/` (CLAUDE.md, roadmap.md, TODO.md, tokens, catalogs)
5. Commit initial

### Manuellement

```bash
mkdir mon-projet && cd mon-projet && git init
git submodule add https://github.com/aztuk/solo-dev-system.git AgenticSystem
mkdir tasks system design-system && mkdir -p .claude/rules
# copier les fichiers depuis AgenticSystem/boilerplate/ a la racine
git add . && git commit -m "chore: init projet avec submodule AgenticSystem"
```

### Apres creation

Les fichiers systeme (`governance.md`, `access-control.md`, `agent-patterns.md`) restent dans `AgenticSystem/system/` et sont lus par tous les agents depuis le submodule. Seuls les fichiers projet vivent a la racine.

1. Renseigner `system/governance.md` : stack, conventions, scope.
2. Adapter `system/access-control.md` aux dossiers reels du projet.
3. Remplir ou synchroniser `system/tokens.md`.
4. Ajouter les premieres demandes dans `TODO.md`.
5. Ouvrir le projet dans Claude Code et demander : "prochaine tache".
