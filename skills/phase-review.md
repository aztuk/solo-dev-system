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

## Sécurité
[Injection, secrets hardcodés, surface d'attaque élargie, validation manquante aux frontières — ou "aucun"]

## Performance
[Complexité algorithmique, appels inutiles, N+1, re-renders inutiles — ou "aucun"]

## Verdict
[Approuvé / Approuvé avec réserves / À corriger]
```

### Étape 2 — Anti-rationalisations à ne pas accepter

Avant de soumettre, vérifier que le diff ne contient pas ces rationalisations courantes :

| Raccourci | Rationalisation fausse |
|---|---|
| Pas de validation input | "c'est un appel interne" |
| Secret dans le code | "c'est temporaire" |
| Copier-coller de logique | "c'est légèrement différent" |
| Fichier > 250 lignes sans extraction | "c'est cohérent dans un seul fichier" |
| Pas de test pour le chemin heureux | "c'est trivial, ça se voit" |

Si un de ces patterns est présent : le signaler dans "Bugs détectés" ou "Simplifications possibles", pas l'ignorer.

Soumettre à l'humain. Attendre validation avant de continuer.

Si verdict "À corriger" : arrêter, lister les corrections nécessaires, attendre que l'humain confirme les corrections avant de reprendre.
