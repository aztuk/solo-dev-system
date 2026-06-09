# Skill — phase-review

## Déclencheur

Option 3 de la Review à la carte : diff review.

## Contexte chargé

Diff git uniquement. Ne pas charger `plan.md` ni `exploration.md`.

## Modèle recommandé

`mid`

---

## Comportement

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
