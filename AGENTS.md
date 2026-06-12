# AGENTS.md — Orchestrateur

Protocole commun à tous les agents (Claude Code, Codex). Les skills ne s'appellent jamais entre eux.

**Hiérarchie** : Humain → AGENTS.md → Skills

---

## Règle d'entrée

Au premier message d'une session, exécuter `skills/session-start.md` (une seule fois par session).

| Mode | Déclencheur |
|---|---|
| `consultation` | Question, analyse, explication, aucune écriture demandée |
| `implementation` | Créer, modifier, corriger, ajouter, committer |

---

## Session state

Chaque session possède son propre fichier d'état dans `system/.session-state/<id>.md` (gitignoré).

- Claude Code / Cursor : utiliser `SESSION_STATE_FILE` si injecté.
- Codex : générer un ID unique au démarrage.
- Une session lit et écrit uniquement son propre fichier.
- Coordination inter-agents : uniquement via les statuts de `roadmap.md`.
- Nettoyage : supprimer en Phase 7 ; orphelins > 24h supprimés au démarrage.

Format défini dans `skills/session-start.md`. Ne relire les fichiers complets que si le cache est absent ou insuffisant. Logguer les lectures significatives dans le `Context usage log`.

---

## Règles spécifiques à Codex

- Ne jamais lancer de serveur de développement sauf demande explicite.
- Ne jamais prendre de screenshots sauf demande explicite.
- En Review : exécuter `skills/unit-tests.md` uniquement si l'option `2` est sélectionnée.
- Si vérification visuelle utile : proposer comme test manuel en Phase 6.

---

## Skills disponibles

| Skill | Déclencheur |
|---|---|
| `skills/session-start.md` | Début de session |
| `skills/next-task.md` | "Prochaine tâche de la stack" ou équivalent |
| `skills/sync-todo.md` | Après commit, orchestré par AGENTS.md |
| `skills/grill-me.md` | Avant la Phase Exploration ; ou demande explicite de clarification/stress-test |
| `skills/phase-exploration.md` | Phase Exploration d'une tâche |
| `skills/phase-plan.md` | Phase Planification d'une tâche |
| `skills/phase-implementation.md` | Phase Implémentation d'une tâche |
| `skills/phase-review.md` | Option 3 de la Review : diff review |
| `skills/review-responsibilities.md` | Option 4 de la Review : responsabilités découpées |
| `skills/product-challenge.md` | Pour toute tâche M+ (Dev, Design, Produit) |
| `skills/design-audit.md` | Avant toute création ou modification de composant ou valeur visuelle |
| `skills/implementation-guardrails.md` | Avant tout code, orchestré par AGENTS.md |
| `skills/doubt-check.md` | Dans phase-implementation, avant escalade humain sur décision imprévue |
| `skills/debugging.md` | Sur demande explicite quand quelque chose ne fonctionne pas |
| `skills/unit-tests.md` | Option 2 de la Review : tests unitaires |
| `skills/compliance.md` | Option 1 de la Review : compliance design system |
| `skills/figma-sync.md` | Après mise à jour de la page Tokens, composants ou flows dans Figma |
| `skills/commit-protocol.md` | Option 5 de la Review : commit |
| `skills/update-system.md` | Après décision humaine à impact long terme |
| `skills/create-skill.md` | Quand une décision humaine implique un nouveau skill |
| `skills/create-project.md` | Créer un nouveau repo projet avec AgenticSystem comme submodule |

Pour le spawning de subagents et le routing de modèle : `system/agent-patterns.md`.

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

Exécuter `skills/session-start.md`. La synchronisation `TODO.md` → `roadmap.md` n'a plus lieu au démarrage.

Pour identifier la prochaine tâche : exécuter `skills/next-task.md`.

### Routing par phase

Chaque tâche dans `roadmap.md` a un pipeline (`Explo→Plan→Impl→Review`). Déléguer au skill de la phase courante :

| Phase courante | Skill à exécuter |
|---|---|
| Exploration | `skills/grill-me.md`, puis `skills/phase-exploration.md` |
| Planification | `skills/phase-plan.md` |
| Implémentation | `skills/implementation-guardrails.md` si code touché, puis `skills/phase-implementation.md` |
| Review | Menu Review à la carte, puis options sélectionnées |

Le handoff produit par `skills/grill-me.md` reste dans le contexte courant et sert d'entrée à `skills/phase-exploration.md`. Aucun skill ne délègue à un autre skill : cet enchaînement est orchestré uniquement par AGENTS.md.

Si M+ : exécuter `skills/product-challenge.md` avant la phase Planification.
Si UI/composant touché : exécuter `skills/design-audit.md` avant l'implémentation.
Si tâche Design seule : Figma → `figma-sync.md` si tokens/composants/flows → clôture.

### Review à la carte

Au démarrage de la phase Review, afficher :

```
Review à la carte — sélectionne les checks à lancer :
1 Compliance design system
2 Tests unitaires
3 Diff review
4 Responsabilités découpées
5 Commit

Réponse attendue : chiffres sans séparateur, ex. 135.
```

Attendre la réponse humaine. Exécuter uniquement les options sélectionnées, dans l'ordre numérique :

| Option | Action orchestrée par AGENTS.md |
|---|---|
| 1 | Exécuter `skills/compliance.md` en mode `design-system` |
| 2 | Exécuter `skills/unit-tests.md` |
| 3 | Exécuter `skills/phase-review.md` |
| 4 | Exécuter `skills/review-responsibilities.md` |
| 5 | Exécuter `skills/commit-protocol.md` |

Ne jamais lancer une option non sélectionnée. Si `5` est sélectionné, `commit-protocol.md` vérifie ses propres prérequis avant commit.

### Clôture

Exécutée par `skills/commit-protocol.md` si l'option `5` a été sélectionnée et validée. Après commit :
1. Exécuter `skills/sync-todo.md`.
2. Évaluer `system/memory.md` (cf. commit-protocol Étape 7).
3. Supprimer le fichier de session.

---

## Règles transversales

- Jamais de décision seul : produit, architecture, gouvernance → validation humaine.
- Jamais d'écriture non autorisée : vérifier `access-control.md`.
- Jamais de valeur visuelle hardcodée.
- Jamais de composant créé sans audit applicable.
- Jamais de commit sans compliance validé.
- Pas d'imbrication : les skills ne s'appellent jamais entre eux.
