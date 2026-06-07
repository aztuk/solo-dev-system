---
description: Format rules for roadmap.md
globs: roadmap.md
---

- roadmap.md est un index, pas un stockage d'état.
- Ne jamais écrire d'état inline dans une ligne de tâche.
- Les artefacts de la tâche vivent dans tasks/<slug>/.
- Objectif : rester sous 60 lignes total.
- Colonnes obligatoires : Phase | Tâche | Pipeline | Modèle | Priorité | Dossier.
- Valeurs Phase : à faire | Exploration | Planification | Implémentation | Review | fait.
- Valeurs Modèle : low | mid | high.
- Review est toujours la dernière phase du pipeline (jamais optionnelle).
