# Skill — session-start

## Déclencheur

Début de chaque session, avant toute réponse ou action.

---

## Modes

| Mode | Quand |
|---|---|
| `consultation` | Question, analyse, explication, aucune écriture demandée |
| `implementation` | Création, modification, correction, ajout, commit |

Si le mode n'est pas évident : `consultation` si aucune écriture, `implementation` dès qu'une modification est demandée.

---

## Étape 1 — Initialisation session

- Sweep des orphelins : supprimer dans `system/.session-state/` tout fichier `*.md` dont la dernière modification dépasse 24h.
- Générer un ID de session unique (timestamp + random court) et retenir `system/.session-state/<id>.md`.
- Ne jamais lire les fichiers de session des autres agents.

Créer le fichier de session :

```
# Session state

**Phase session** : consultation / implementation
**Tâche**         : [nom ou N/A]
**Phase tâche**   : [Analyse/Implémentation/Review ou N/A]
**Modèle**        : [low/mid/high ou N/A]
**Artefact**      : [chemin chargé ou aucun]

**Cache governance** : [2-3 règles non négociables pertinentes]
**Cache access**     : [fichiers autorisés pour cette tâche]

**Context usage log** :
| Heure | Action | Fichier | Taille |
|---|---|---|---|
```

---

## Étape 2 — Cache minimal

Lire `system/governance.md` et `system/access-control.md` uniquement si le cache est absent.

Écrire dans le session-state un résumé court (2-3 règles max, fichiers autorisés pour la tâche). Ne pas copier les fichiers complets.

---

## Étape 3 — Mode consultation

1. Ne pas lire `TODO.md`, `roadmap.md`, ni aucun artefact de tâche.
2. Rendre la main à AGENTS.md pour répondre directement.

---

## Étape 4 — Mode implementation

1. Si déclenché par `next-task.md` : l'artefact de phase est déjà chargé, ne pas recharger.
2. Si déclenché directement : identifier la tâche et charger l'artefact approprié (une lecture max).
3. Ne pas lire `TODO.md`. Ne jamais charger plus d'un artefact de tâche par session.

**Règle absolue** : `session-start.md` ne charge jamais plus d'un artefact de tâche par session.
