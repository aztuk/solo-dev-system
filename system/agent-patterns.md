# Agent Patterns

Référence pour le spawning de subagents et le routing de modèle.

## Routing modèle

| Valeur roadmap | Modèle Claude | Quand |
|---|---|---|
| `low` | claude-haiku-4-5 | Interview Grill, recherche codebase, tâches XS |
| `mid` | claude-sonnet-4-6 | Analyse, Implémentation standard, Review |
| `high` | claude-opus-4-8 | Implémentation L/XL, débogage complexe |

## Patterns de subagents

### Explore
- **Rôle** : recherche codebase, lecture fichiers, analyse
- **Outils** : lecture seule (Glob, Grep, Read, WebSearch)
- **Modèle** : `low`
- **Sortie** : `tasks/<slug>/exploration.md` (~200 lignes max)

### Plan
- **Rôle** : architecture, découpage en étapes, identification des risques
- **Outils** : lecture seule (plan mode)
- **Modèle** : selon roadmap (`mid` ou `high`)
- **Sortie** : `tasks/<slug>/plan.md` (~100 lignes max), validé par l'humain avant implémentation

### Implement
- **Rôle** : écriture de code selon le plan validé
- **Outils** : tous
- **Modèle** : selon roadmap
- **Contexte chargé** : `tasks/<slug>/plan.md` uniquement

### Review
- **Rôle** : review à la carte sélectionnée par l'humain
- **Outils** : lecture seule + git diff
- **Modèle** : `mid`
- **Contexte chargé** : diff git uniquement
- **Options** : compliance design system, tests unitaires, diff review, responsabilités découpées, commit
- **Sortie** : selon options sélectionnées ; `tasks/<slug>/review.md` seulement pour la diff review

## Règle de distillation

| Phase en cours | Fichier chargé | Fichiers exclus |
|---|---|---|
| Analyse | rien (session fraîche) | tout |
| Implémentation | `plan.md` uniquement | `exploration.md`, roadmap |
| Review | diff git uniquement | `plan.md`, `exploration.md` |

Chaque artefact de phase est auto-suffisant pour la phase suivante.
L'agent de la phase N ne lit jamais les artefacts des phases N-2 et antérieures.
