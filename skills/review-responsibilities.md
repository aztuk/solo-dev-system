# Skill — review-responsibilities

## Déclencheur

Option 4 de la Review à la carte : vérifier que les responsabilités restent découpées.

## Contexte chargé

Diff git et fichiers modifiés uniquement. Ne pas charger `plan.md` ni `exploration.md`.

## Modèle recommandé

`mid`

---

## Protocole

### 1. Collecter le périmètre

Lister les fichiers créés ou modifiés par le diff. Ignorer les fichiers générés, lockfiles, assets binaires et artefacts de session.

### 2. Auditer les responsabilités

Pour chaque fichier de code ou protocole modifié, vérifier :
- Une responsabilité principale identifiable en une phrase.
- Pas de mélange entre orchestration, accès data, logique métier, rendu UI, formatage et tests dans le même fichier.
- Pas de fichier `utils`, `helpers`, `common` ou équivalent qui accumule des responsabilités sans thème clair.
- Pas de nouveau fichier dépassant 150 lignes sans justification forte.
- Pas d'ajout de logique dans un fichier de plus de 250 lignes sans extraction ou validation humaine.

Préférence explicite : plusieurs petits fichiers cohérents plutôt qu'un fichier omnibus. Ne pas fusionner des responsabilités distinctes pour réduire le nombre de fichiers.

### 3. Rapport

Afficher uniquement dans le chat :

```markdown
Review responsabilités — [nom tâche]

## Verdict
PASSÉ / À CORRIGER

## Fichiers OK
[liste courte ou "aucun"]

## Responsabilités à découper
[fichier] — [problème] — [extraction recommandée]
```

Si le verdict est `À CORRIGER`, arrêter la review et attendre validation humaine avant toute correction.
