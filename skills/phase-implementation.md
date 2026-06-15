# Skill — phase-implementation

## Déclencheur

Phase Implémentation d'une tâche (sélectionnée via `next-task.md` ou demande explicite).

## Contexte chargé

`tasks/<slug>/plan.md` uniquement.

## Modèle recommandé

Selon roadmap.

---

## Comportement

### Étape 1 — Guardrails

Vérifier que `AGENTS.md` a exécuté `skills/implementation-guardrails.md` avant toute écriture de code si l'implémentation touche du code exécutable.

Si les guardrails requis n'ont pas été exécutés : arrêter et rendre la main à `AGENTS.md`.

### Étape 2 — Implémentation

Implémenter selon le plan validé. Ne pas dévier sans demander à l'humain.

Règles de responsabilité fichier :
- Un fichier = une responsabilité
- Préférer 10 fichiers cohérents de 30 lignes à 1 fichier omnibus de 300 lignes
- Taille cible d'un nouveau fichier : 30 à 80 lignes
- Si un fichier dépasse 150 lignes : justifier que sa responsabilité reste unique
- Si un fichier dépasse 250 lignes : extraire avant d'ajouter de la logique, sauf validation humaine
- Extraire dès que deux responsabilités évoluent séparément
- Ne pas créer de fichier fourre-tout (`utils`, `helpers`, `common`) sans thème précis

### Étape 3 — Vérification composants

Ne pas créer de nouveaux composants sans avoir vérifié le catalog (normalement déjà fait en Analyse). Si un composant manquant est découvert : stopper et demander à l'humain.

### Étape 4 — Décisions imprévues

Si une décision produit ou architecture imprévue apparaît pendant l'implémentation : exécuter `skills/doubt-check.md` d'abord. Escalader à l'humain uniquement si doubt-check conclut que l'escalade est nécessaire. Ne jamais décider seul sans avoir passé doubt-check.

### Étape 5 — Test manuel

Avant de passer en Review, rédiger une liste de scénarios à tester manuellement :

```markdown
## Tests manuels

1. [scénario — chemin heureux]
2. [scénario — cas limite ou erreur attendue]
3. [autre scénario pertinent]
...

Tester chaque point et indiquer : ✓ OK / ✗ KO [description du problème].
```

Attendre le retour de l'humain. Pour chaque point KO :
- Corriger et relancer uniquement les tests affectés.
- Répéter jusqu'à ce que tous les points soient OK.

Ne pas passer à la Review tant qu'un test est KO.

### Étape 6 — Mise à jour roadmap

Passer la phase de `Implémentation` à `Review` dans `roadmap.md`.

Afficher :
```
Implémentation terminée.
Prochaine phase : Review — afficher le menu Review à la carte
```
