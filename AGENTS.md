# AGENTS.md — Orchestrateur

Protocole commun à tous les agents (Claude Code, Codex). Les skills ne s'appellent jamais entre eux.

**Hiérarchie** : Humain → AGENTS.md → Skills

---

## Règle d'entrée

Au premier message d'une session, exécuter `skills/session-start.md` (une seule fois par session).

---

## Session state

Fichier propre à chaque session dans `system/.session-state/<id>.md` (gitignoré). Une session lit et écrit uniquement son propre fichier. Coordination inter-agents : via les statuts de `roadmap.md` uniquement. Format défini dans `skills/session-start.md`.

**Récupération de contexte** : si la tâche en cours, la phase ou l'artefact chargé sont incertains, lire le fichier session-state avant de répondre ou d'agir — ne pas demander à l'humain de répéter. Si l'ID de session est oublié, lister le dossier et prendre le plus récent :
```
ls -t system/.session-state/*.md | head -1
```

---

## Règles spécifiques à Codex

- Ne jamais lancer de serveur de développement sauf demande explicite.
- Ne jamais prendre de screenshots sauf demande explicite.
- En Review : exécuter `skills/unit-tests.md` uniquement si l'option `2` est sélectionnée.

---

## Skills disponibles

| Skill | Déclencheur |
|---|---|
| `skills/session-start.md` | Début de session |
| `skills/next-task.md` | Prochaine tâche |
| `skills/grill-me.md` | Avant Phase Analyse ; clarification explicite |
| `skills/phase-analyse.md` | Phase Analyse |
| `skills/phase-implementation.md` | Phase Implémentation |
| `skills/implementation-guardrails.md` | Avant tout code |
| `skills/phase-review.md` | Option 3 Review |
| `skills/review-responsibilities.md` | Option 4 Review |
| `skills/compliance.md` | Option 1 Review |
| `skills/unit-tests.md` | Option 2 Review |
| `skills/commit-protocol.md` | Option 5 Review |
| `skills/sync-todo.md` | Après commit |
| `skills/product-challenge.md` | Tâche M+ |
| `skills/design-audit.md` | Avant implémentation UI |
| `skills/doubt-check.md` | Décision imprévue en implémentation |
| `skills/debugging.md` | Demande explicite de débogage |
| `skills/figma-sync.md` | Mise à jour Figma tokens/composants |
| `skills/update-system.md` | Décision à impact long terme |
| `skills/create-skill.md` | Nouveau skill décidé par l'humain |
| `skills/create-project.md` | Nouveau repo projet |

Routing modèle et spawning : `system/agent-patterns.md`.

Avant chaque délégation, vérifier `system/access-control.md`. En cas de mismatch :

```
⚠️ Mismatch access-control détecté
Fichier cible    : [fichier]
Éditeur attendu  : [skill ou agent autorisé]
Éditeur réel     : [skill ou agent qui tente l'écriture]
Action           : bloqué — attente de validation humaine
```

---

## Demandes hors roadmap

Les nouvelles tâches entrent via `skills/sync-todo.md` (depuis `TODO.md`), jamais directement dans `roadmap.md`.

Si la tâche n'existe pas dans `roadmap.md` :

```
⚠️ Tâche hors roadmap détectée
Demande : [description]

Options :
1. Je l'ajoute au suivi et on suit le protocole normal
2. Exception urgente — j'exécute maintenant, tracée en fin de session
3. On abandonne cette demande
```

---

## Exécution d'une tâche

### Démarrage

Exécuter `skills/session-start.md`. Pour la prochaine tâche : `skills/next-task.md`.

### Routing par phase

Pipeline : `Analyse→Impl→Review`.

| Phase | Skill à exécuter |
|---|---|
| Analyse | `skills/grill-me.md`, puis `skills/phase-analyse.md` |
| Implémentation | `skills/implementation-guardrails.md` si code touché, puis `skills/phase-implementation.md` |
| Review | Menu Review à la carte, puis options sélectionnées |

Si M+ : `skills/product-challenge.md` avant Analyse.
Si UI/composant : `skills/design-audit.md` avant Implémentation.
Si tâche Design seule : Figma → `figma-sync.md` si tokens/composants/flows → clôture.

### Review à la carte

```
Review à la carte — sélectionne les checks à lancer :
1 Compliance design system
2 Tests unitaires
3 Diff review
4 Responsabilités découpées
5 Commit

Réponse attendue : chiffres sans séparateur, ex. 135.
```

| Option | Action |
|---|---|
| 1 | `skills/compliance.md` |
| 2 | `skills/unit-tests.md` |
| 3 | `skills/phase-review.md` |
| 4 | `skills/review-responsibilities.md` |
| 5 | `skills/commit-protocol.md` |

Exécuter uniquement les options sélectionnées, dans l'ordre numérique. Si `5` est sélectionné, `commit-protocol.md` vérifie ses prérequis.

### Clôture

Gérée par `skills/commit-protocol.md`. Après commit : `skills/sync-todo.md`, évaluer `system/memory.md`, supprimer le fichier de session.

---

## Règles transversales

- Jamais de décision seul : produit, architecture, gouvernance → validation humaine.
- Jamais d'écriture non autorisée : vérifier `access-control.md`.
- Jamais de valeur visuelle hardcodée.
- Jamais de composant créé sans audit.
- Jamais de commit sans compliance validé.
- Pas d'imbrication : les skills ne s'appellent jamais entre eux.
