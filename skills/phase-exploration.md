# Skill — phase-exploration

## Déclencheur

Phase Exploration d'une tâche (sélectionnée via `next-task.md` ou demande explicite).

## Contexte chargé

Rien — session fraîche. Ne pas lire d'artefact de tâche avant l'interview.

## Modèle recommandé

`low` (Haiku)

---

## Comportement

### Étape 1 — Grill-me

Interviewer l'humain de façon systématique. Pour chaque aspect, fournir une recommandation, attendre la réponse avant de passer au suivant.

Questions à couvrir dans l'ordre :
1. Quel est le problème exact (pas la solution) ?
2. Qui est impacté, dans quel contexte ?
3. Quelles contraintes techniques connues ?
4. Qu'est-ce qui a déjà été essayé ?
5. Quels sont les edge cases évidents ?

Si une question peut être résolue en explorant la codebase : explorer plutôt que demander.

### Étape 2 — Exploration codebase (si nécessaire)

Utiliser Glob/Grep/Read pour répondre aux questions techniques. Logger chaque lecture dans le context usage log du session-state.

### Étape 3 — Validation de l'interview

Demander à l'humain si l'interview est complète avant de rédiger.

### Étape 4 — Rédaction exploration.md

Créer `tasks/<slug>/exploration.md` (200 lignes max).

```markdown
# Exploration — [nom tâche]

## Contexte
[Ce que l'interview a révélé — 3-5 phrases]

## Observations
[Findings codebase — bullet points, ou "aucune exploration codebase effectuée"]

## Questions ouvertes
[Ce qui reste non résolu — bullet points, ou "aucune"]

## Recommandation
[Direction suggérée en 3-5 phrases, auto-suffisante pour la Planification]
```

### Étape 5 — Mise à jour roadmap

Passer la phase de la tâche de `Exploration` à `Planification` dans `roadmap.md`.

Afficher :
```
Exploration terminée.
Artefact : tasks/<slug>/exploration.md
Prochaine phase : Planification
```
