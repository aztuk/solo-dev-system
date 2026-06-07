# Skill — sync-todo

## Déclencheur

Déclenché uniquement par `skills/commit-protocol.md`. Jamais déclenché directement par un agent ou une demande humaine.

---

## Comportement

### Étape 1 — Lecture TODO

Lire `TODO.md`. Si aucune entrée (fichier vide ou uniquement des commentaires), afficher "TODO vide — rien à synchroniser" et arrêter.

### Étape 2 — Analyse des entrées

Pour chaque entrée dans `TODO.md` :

1. Déduire une description courte (1 ligne)
2. Déduire le pipeline adapté :
   - Correction évidente, XS → `Impl`
   - Tâche définie, petite → `Plan→Impl`
   - Tâche vague, grande ou inconnue → `Explo→Plan→Impl→Review`
3. Déduire le modèle :
   - XS/S → `low`
   - M → `mid`
   - L/XL → `high`
4. Déduire la priorité (P2 par défaut si non évidente)
5. Vérifier si une tâche similaire existe déjà dans `roadmap.md` (dédupliquer)

### Étape 3 — Mise à jour roadmap

Ajouter les nouvelles tâches dans `roadmap.md` avec phase `à faire`.

Format de chaque ligne :

```
| à faire | [description] | [pipeline] | [modèle] | [priorité] | — |
```

### Étape 4 — Vider TODO

Garder le header de `TODO.md`, supprimer toutes les entrées.

### Étape 5 — Résumé

Afficher :

```
Sync TODO → Roadmap terminée.
Tâches ajoutées : [n]
[liste des tâches ajoutées]
Tâches ignorées (doublons) : [n ou aucune]
```
