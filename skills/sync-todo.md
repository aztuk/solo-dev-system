# Skill — sync-todo

## Déclencheur

Déclenché uniquement par AGENTS.md après un commit validé. Jamais déclenché directement par une demande humaine.

---

## Comportement

### Étape 1 — Lecture TODO

Lire `TODO.md`. Si aucune entrée (fichier vide ou uniquement des commentaires), afficher "TODO vide — rien à synchroniser" et arrêter.

### Étape 2 — Analyse des entrées

Pour chaque entrée dans `TODO.md` :

1. Copier la description de la tâche depuis `TODO.md` littéralement, sans résumé, simplification, reformulation, correction stylistique ni perte de détails.
   - Si l'entrée contient plusieurs lignes, conserver le contenu complet de la description.
   - Ne normaliser que le minimum nécessaire au format `roadmap.md` (ex. échapper les caractères qui casseraient le tableau Markdown), sans changer le sens ni retirer d'information.
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

`[description]` doit contenir la description copiée depuis `TODO.md` selon l'Étape 2. Elle ne doit pas être raccourcie pour tenir sur une ligne.

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
