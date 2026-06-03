# Agent System Template

Un système d'orchestration IA pour projets solo ou en petite équipe. Il structure la collaboration entre un humain et plusieurs agents IA (Claude Code, Codex, Cursor) autour d'un protocole partagé, d'un design system synchronisé depuis Figma, et d'un contrôle strict des décisions.

---

## Comment ça fonctionne

```
Niveau 0 : Humain
Niveau 1 : AGENTS.md  ←  orchestrateur unique, lu par tous les agents
Niveau 2 : Skills     ←  actions atomiques déclenchées par AGENTS.md
```

**`AGENTS.md`** est le seul fichier que tous les agents lisent en premier. Il définit le protocole de session, les règles de décision, les skills disponibles et les gardes-fous. Chaque outil IA (Claude Code, Cursor, Codex) dispose d'un adapter minimal qui pointe vers lui.

**Les skills** (`skills/`) sont des actions atomiques : démarrer une session, auditer un composant, synchroniser Figma, committer. Un skill ne délègue jamais à un autre skill — toute orchestration remonte dans `AGENTS.md`.

**Les fichiers système** (`system/`) stockent les décisions durables : gouvernance, tokens, mémoire des trade-offs, contrôle d'accès. Aucun agent ne les modifie librement — chaque fichier a un éditeur autorisé défini dans `system/access-control.md`.

---

## Utilisation après fork

### 1. Configurer le projet

Renseigner la stack et les conventions dans `system/governance.md` :
- Section **Stack technique** : technologies choisies
- Section **Conventions de nommage** : adapter si nécessaire
- Section **Scope** : ce qui est inclus et exclu du projet

### 2. Créer un dossier de specs

Créer un dossier pour les spécifications des features (ex: `specs/`). Pour chaque feature, un fichier Markdown décrivant le comportement attendu, les règles métier et les états UI.

Mettre à jour la référence dans `system/governance.md` → section **Fichiers de référence** → ligne *Specs features*.

Mettre à jour `AGENTS.md` → Phase 3a → remplacer *"dossier de specs défini dans `system/governance.md`"* par le chemin réel.

### 3. Connecter Figma (optionnel)

Si le projet a un fichier Figma :
- Renseigner l'URL du fichier dans `system/governance.md`
- Exécuter `skills/figma-sync.md` pour peupler `system/tokens.md` et `design-system/`

Si pas de Figma, renseigner manuellement les tokens dans `system/tokens.md` et désactiver les références à `figma-sync.md` dans `AGENTS.md`.

### 4. Créer les premières tâches

Écrire librement dans `TODO.md` — une idée par ligne, sans format imposé :

```
Créer la page d'accueil
Setup authentification
Définir le modèle de données utilisateur
```

À la prochaine session, l'agent lit `TODO.md`, classe chaque entrée (catégorie, priorité, difficulté) et l'ajoute dans `roadmap.md`. `TODO.md` est ensuite vidé.

### 5. Démarrer une session

Ouvrir une conversation avec Claude Code (ou Cursor, Codex). L'agent exécute automatiquement `skills/session-start.md` qui :
1. Synchronise `TODO.md` → `roadmap.md`
2. Propose la tâche la plus prioritaire
3. Attend la validation avant d'agir

---

## Structure des fichiers

```
AGENTS.md                        ← protocole unique, lu par tous les agents
CLAUDE.md                        ← adapter Claude Code
.cursor/rules/protocol.mdc       ← adapter Cursor
TODO.md                          ← dump libre de tâches (humain → agents)
roadmap.md                       ← backlog structuré (géré par les agents)
later.md                         ← décisions temporaires à revoir plus tard

system/
  governance.md                  ← stack, conventions, règles non-négociables
  tokens.md                      ← design tokens (sync depuis Figma)
  memory.md                      ← journal des décisions et trade-offs
  access-control.md              ← qui peut écrire quoi et par quel chemin

design-system/
  component-catalog.md           ← index des composants
  flows-catalog.md               ← index des flows/parcours
  components/                    ← documentation de chaque composant
  flows/                         ← documentation de chaque flow

skills/
  session-start.md               ← démarrage de session (sync TODO + proposition tâche)
  design-audit.md                ← audit composant + token avant implémentation
  scaffold-feature.md            ← création des stubs de fichiers d'une feature
  compliance.md                  ← audit post-implémentation avant commit
  figma-sync.md                  ← synchronisation Figma → tokens.md + design-system/
  commit-protocol.md             ← vérification + commit + clôture session
  update-system.md               ← mise à jour des fichiers système après décision humaine
  create-skill.md                ← création d'un nouveau skill
```

---

## Règles fondamentales

- **Jamais de décision seul** : toute décision produit, architecture ou gouvernance est proposée à l'humain avec une recommandation. L'agent attend la validation.
- **Jamais de valeur hardcodée** : toute valeur visuelle vient de `system/tokens.md`.
- **Jamais de commit sans compliance** : le commit ne se fait qu'après validation humaine explicite du rapport compliance.
- **Figma est la source de vérité** : les specs sont un point de départ, pas une référence finale.
- **Pas d'imbrication** : les skills ne s'appellent jamais entre eux.
