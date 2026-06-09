# Skill — phase-exploration

## Déclencheur

Phase Exploration d'une tâche (sélectionnée via `next-task.md` ou demande explicite).

## Contexte chargé

Le handoff produit par `skills/grill-me.md` doit être présent dans le contexte courant. Ne pas relancer l'interview complète ici : cette phase consolide, vérifie les derniers trous bloquants et rédige l'artefact.

## Modèle recommandé

`low` (Haiku)

---

## Comportement

### Étape 1 — Vérification du handoff

Vérifier que le contexte contient un `Grill handoff` suffisant pour rédiger l'exploration :
- intent ;
- contraintes ;
- décisions clés ;
- hypothèses surfacées ;
- alternatives écartées ;
- hors scope ;
- questions ouvertes.

Si le handoff est absent ou insuffisant, ne pas appeler un autre skill depuis cette phase. Rendre la main à AGENTS.md avec :

```markdown
Exploration bloquée : `skills/grill-me.md` doit être exécuté avant `skills/phase-exploration.md`.
Point manquant : [intent / contraintes / décisions / hypothèses / alternatives / hors scope / questions ouvertes]
```

### Étape 2 — Exploration codebase (si nécessaire)

Utiliser Glob/Grep/Read pour répondre aux questions techniques. Logger chaque lecture dans le context usage log du session-state.

### Étape 3 — Validation de l'exploration

Si des questions ouvertes bloquent la recommandation, poser uniquement ces questions résiduelles. Sinon, demander une validation courte du handoff avant de rédiger.

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
