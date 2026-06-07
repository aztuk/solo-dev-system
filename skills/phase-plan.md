# Skill — phase-plan

## Déclencheur

Phase Planification d'une tâche (sélectionnée via `next-task.md` ou demande explicite).

## Contexte chargé

`tasks/<slug>/exploration.md` si existe. Sinon : aucun artefact.

## Modèle recommandé

Selon roadmap (`mid` ou `high`).

---

## Comportement

### Étape 1 — Vérification composants (si UI touchée)

Si la tâche touche des composants ou l'UI :
- Lire `design-system/component-catalog.md`
- Si un composant existant couvre le besoin : utiliser ou proposer une variante
- Si non : noter explicitement dans le plan avec justification

### Étape 2 — Vérification duplication

Avant de proposer une nouvelle fonction, classe ou module : vérifier via Grep/Glob si une implémentation similaire existe.

### Étape 3 — Rédaction plan.md

Créer `tasks/<slug>/plan.md` (100 lignes max). Auto-suffisant — ne suppose pas que `exploration.md` sera relu.

```markdown
# Plan — [nom tâche]

## Décision
[Approche choisie — 2-3 phrases]

## Composants existants réutilisés
[Liste ou "aucun"]

## Étapes
1. [étape]
2. [étape]

## Fichiers impactés
[Liste]

## Risques
[Liste ou "aucun"]
```

### Étape 4 — Validation humaine

Soumettre le plan à l'humain. Attendre approbation explicite. Ne pas implémenter avant validation.

### Étape 5 — Mise à jour roadmap

Après validation : passer la phase de `Planification` à `Implémentation` dans `roadmap.md`. Renseigner le dossier artefacts si absent.

Afficher :
```
Plan validé.
Artefact : tasks/<slug>/plan.md
Prochaine phase : Implémentation
```
