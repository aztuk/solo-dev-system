# Skill — phase-review

## Déclencheur

Phase Review d'une tâche (sélectionnée via `next-task.md` ou demande explicite).

## Contexte chargé

Diff git uniquement. Ne pas charger `plan.md` ni `exploration.md`.

## Modèle recommandé

`mid`

---

## Comportement — séquence stricte

### Étape 1 — Review du diff

Lire le diff git (`git diff main...HEAD` ou `git diff HEAD~1` selon contexte).

Produire `tasks/<slug>/review.md` (50 lignes max) :

```markdown
# Review — [nom tâche]

## Bugs détectés
[Liste ou "aucun"]

## Simplifications possibles
[Liste ou "aucun"]

## Verdict
[Approuvé / Approuvé avec réserves / À corriger]
```

Soumettre à l'humain. Attendre validation avant de continuer.

Si verdict "À corriger" : arrêter, lister les corrections nécessaires, attendre que l'humain confirme les corrections avant de reprendre.

### Étape 2 — Tests unitaires

Après validation humaine du review : exécuter `skills/unit-tests.md`.

### Étape 3 — Compliance

Exécuter `skills/compliance.md` :
- Mode `lite` si tâche XS/S
- Mode `full` si tâche M+

Attendre que tous les audits soient `PASSÉ`.

### Étape 4 — Commit

Exécuter `skills/commit-protocol.md`. Le commit protocol :
- Archive les artefacts de la tâche (`tasks/<slug>/`)
- Marque la tâche `fait` dans `roadmap.md`
- Déclenche `skills/sync-todo.md`

Ne pas passer à l'étape 4 si des audits compliance sont en échec.
