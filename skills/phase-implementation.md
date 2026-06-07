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

Exécuter `skills/implementation-guardrails.md` avant toute écriture de code.

### Étape 2 — Implémentation

Implémenter selon le plan validé. Ne pas dévier sans demander à l'humain.

Règles de responsabilité fichier :
- Un fichier = une responsabilité
- Taille cible : < 300 lignes par fichier
- Si un fichier dépasse 300 lignes : vérifier si une extraction est justifiée
- Ne pas extraire uniquement pour réduire la taille

### Étape 3 — Vérification composants

Ne pas créer de nouveaux composants sans avoir vérifié le catalog (normalement déjà fait en Planification). Si un composant manquant est découvert : stopper et demander à l'humain.

### Étape 4 — Décisions imprévues

Si une décision produit ou architecture imprévue apparaît pendant l'implémentation : stopper immédiatement et demander à l'humain. Ne jamais décider seul.

### Étape 5 — Mise à jour roadmap

Passer la phase de `Implémentation` à `Review` dans `roadmap.md`.

Afficher :
```
Implémentation terminée.
Prochaine phase : Review — exécuter skills/phase-review.md
```
