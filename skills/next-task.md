# Skill — next-task

## Déclencheur

"Prochaine tâche de la stack" ou équivalent ("quelle est la prochaine tâche", "on attaque quoi", etc.).

---

## Comportement

### Étape 1 — Sync TODO si nécessaire

Lire `TODO.md`. Si des entrées non commentées sont présentes, exécuter `skills/sync-todo.md` avant de continuer.

### Étape 2 — Lecture roadmap

Lire `roadmap.md`. Identifier :
- Les tâches avec une phase active (`Analyse`, `Implémentation`, `Review`)
- Les tâches `à faire`

### Étape 3 — Présentation des choix

Afficher :

```
Tâches en cours :
  T-NNN [Phase / Modèle] Nom de la tâche (Priorité) — dossier
  ...

Tâches à démarrer :
  T-NNN [Priorité] Nom — pipeline: X / modèle: Y
  ...
```

Attendre la sélection humaine. Ne pas charger les artefacts avant.

### Étape 4 — Chargement ciblé

Après sélection :

1. Identifier la phase courante de la tâche dans `roadmap.md`
2. Charger uniquement l'artefact de la phase précédente selon la règle de distillation :

| Phase à exécuter | Artefact à charger |
|---|---|
| Analyse | aucun |
| Implémentation | `tasks/<slug>/plan.md` |
| Review | diff git uniquement |

3. Mettre à jour le session-state :

```
Tâche sélectionnée : [nom]
Phase à exécuter   : [phase]
Modèle recommandé  : [low/mid/high]
Artefact chargé    : [chemin ou "aucun"]
```

4. Passer la main à AGENTS.md pour exécuter la phase.
