# Skill — design-audit

## Déclencheur

Ce skill s'exécute dans deux situations :
1. **Avant d'implémenter** un composant ou une valeur visuelle (appelé par AGENTS.md en phase de planification).
2. **En cours d'implémentation** si un composant ou token manquant est détecté.

---

## Partie 1 — Audit composant

### Étape 1 : Lire l'index

Lire `design-system/component-catalog.md` et identifier tous les composants existants.

### Étape 2 : Arbitrage

| Situation | Action |
|---|---|
| Un composant couvre exactement le besoin | Réutiliser. Documenter dans le code pourquoi ce composant a été choisi. |
| Un composant est proche mais incomplet | Proposer à l'humain une extension du composant existant (nouvelle variante ou state). Attendre validation avant de modifier. |
| Aucun composant ne couvre le besoin | Proposer à l'humain la création d'un nouveau composant avec : nom, variantes prévues, tokens utilisés. Attendre validation. |

### Étape 3 : Si création validée

1. Créer le fichier `design-system/components/[nom-composant].md` avec le template standard.
2. Ajouter l'entrée dans `design-system/component-catalog.md` avec statut `draft`.
3. Implémenter le composant dans le code.
4. Mettre à jour le statut dans `component-catalog.md` à `stable` une fois validé par l'humain.

---

## Partie 2 — Audit token

### Étape 1 : Lire les tokens disponibles

Lire `system/tokens.md` et identifier les tokens disponibles (couleurs, typo, spacing, radius).

### Étape 2 : Arbitrage

| Situation | Action |
|---|---|
| Le token existe | Utiliser la classe NativeWind correspondante. Ne jamais hardcoder la valeur. |
| Le token n'existe pas | **Bloquer l'implémentation.** Signaler à l'humain le token manquant. Ne pas inventer de valeur. Attendre que le token soit ajouté dans Figma puis synchronisé via `figma-sync.md`. |
| Valeur hardcodée détectée dans le code existant | La signaler dans le rapport de compliance comme écart à corriger. |

---

## Résultat attendu

À l'issue de ce skill, l'agent doit pouvoir répondre à ces deux questions avant d'implémenter :
- Quel composant vais-je utiliser ou créer, et pourquoi ?
- Quels tokens vais-je utiliser pour chaque valeur visuelle ?

Si l'une des deux réponses est "je ne sais pas encore", l'implémentation ne commence pas.
