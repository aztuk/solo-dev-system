---
description: Format rules for task artifacts in tasks/
globs: tasks/**/*.md
---

Formats imposés par type d'artefact :
- exploration.md : 200 lignes max. Sections : Contexte, Observations, Questions ouvertes, Recommandation.
- plan.md : 100 lignes max. Auto-suffisant (ne suppose pas que exploration.md sera relu). Sections : Décision, Composants réutilisés, Étapes, Fichiers impactés, Risques.
- review.md : 50 lignes max. Basé uniquement sur le diff git. Sections : Bugs, Simplifications, Verdict.
Un artefact trop long n'a pas distillé. Couper, pas tronquer.
