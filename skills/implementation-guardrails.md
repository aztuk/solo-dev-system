# Skill — implementation-guardrails

## Déclencheur

Exécuté par `AGENTS.md` en Phase 5 uniquement si l'implémentation implique d'écrire ou modifier du code.

Inclut : code applicatif, composants, hooks, services, tests, scripts exécutables, migrations, fonctions serverless, middleware, jobs, schemas ou logique de configuration exécutée par l'application.

Ne pas exécuter pour : consultation, documentation seule, protocole seul, fichier de session, roadmap, memory, tokens, catalogues, ou configuration non exécutable sans code.

---

## Objectif

Empêcher les dérives fréquentes pendant l'implémentation :
- duplication de fonctions, composants, hooks ou logique métier ;
- création excessive de fichiers ;
- fichiers qui grossissent sans plan de refactor ;
- nouvelles abstractions non justifiées ;
- chemins parallèles conservés après remplacement.

Ce skill ne prend aucune décision produit, architecture ou gouvernance. Si un arbitrage dépasse l'implémentation locale, stopper et demander validation humaine.

---

## Protocole

### 1. Confirmer le périmètre code

Lister les fichiers de code probablement touchés.

Si aucun code ne doit être écrit, retourner :

```
Implementation guardrails : N/A — aucun code à écrire.
```

Ne pas continuer le skill.

### 2. Scanner la réutilisation

Avant toute écriture :
- rechercher les fonctions, composants, hooks, services, types, helpers et modules proches avec `rg` ;
- vérifier les catalogues design si un composant UI est concerné ;
- identifier les fichiers existants qui peuvent être étendus plutôt que dupliqués.

Sortie attendue :

```
Reuse scan :
- Réutilisé : [...]
- Étendu : [...]
- Nouveau nécessaire : [...] parce que [...]
```

Interdiction : créer une fonction, un composant, un hook, un service ou un helper sans avoir vérifié qu'un équivalent proche n'existe pas déjà.

### 3. Fixer un budget de fichiers

Avant d'écrire, annoncer le budget :

```
File budget :
- Fichiers modifiés prévus : [...]
- Nouveaux fichiers prévus : [n] — justification par fichier
```

Règles :
- XS/S : éviter les nouveaux fichiers sauf nécessité claire.
- M+ : annoncer les nouveaux fichiers dans le plan validé.
- Ne pas créer un fichier pour une abstraction utilisée une seule fois, sauf contrainte locale explicite.
- Ne pas concentrer toute la logique dans un fichier déjà trop long pour éviter de créer un fichier.

### 4. Contrôler la taille des fichiers

Avant et après modification, vérifier la taille des fichiers de code touchés.

Seuils :
- `<= 250` lignes : acceptable.
- `251-400` lignes : continuer seulement si la modification reste locale et le rapport mentionne la dette.
- `> 400` lignes : stopper avant d'ajouter de la logique, sauf validation humaine ou refactor inclus dans la tâche.

Ces seuils sont des garde-fous, pas une invitation à découper artificiellement.

### 5. Contrôler la duplication

Pendant l'implémentation :
- préférer étendre un chemin existant plutôt que créer une variante parallèle ;
- supprimer ou remplacer l'ancien chemin quand une logique est déplacée ;
- ne pas laisser deux implémentations concurrentes d'un même comportement ;
- ne pas copier-coller un bloc de logique sans extraire ou réutiliser le bon niveau d'abstraction.

### 6. Rapport de sortie

Après implémentation, produire dans le chat ou le session-state :

```
Implementation guardrails :
- Reuse scan : PASSÉ / [écarts]
- File budget : PASSÉ / [écarts]
- File size : PASSÉ / [fichiers à surveiller]
- Duplication : PASSÉ / [écarts]
- Décisions humaines requises : Non / [...]
```

Tout écart bloquant doit être corrigé avant `skills/unit-tests.md` ou `skills/compliance.md`.
