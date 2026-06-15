# Skill — phase-analyse

## Déclencheur

Phase Analyse d'une tâche (sélectionnée via `next-task.md` ou demande explicite).
Remplace les anciennes phases Exploration et Planification.

## Contexte chargé

Le handoff produit par `skills/grill-me.md` doit être présent dans le contexte courant.

## Modèle recommandé

Selon roadmap (`mid` ou `high`).

---

## Comportement

### Étape 1 — Vérification du handoff

Vérifier que le contexte contient un `Grill handoff` avec : intent, contraintes, décisions clés, hypothèses surfacées, alternatives écartées, hors scope, questions ouvertes.

Si le handoff est absent ou insuffisant, rendre la main à AGENTS.md :

```markdown
Analyse bloquée : `skills/grill-me.md` doit être exécuté avant `skills/phase-analyse.md`.
Point manquant : [intent / contraintes / décisions / hypothèses / alternatives / hors scope / questions ouvertes]
```

### Étape 2 — Exploration codebase

Utiliser Glob/Grep/Read pour répondre aux questions techniques ouvertes. Logger chaque lecture dans le context usage log du session-state.

### Étape 3 — Vérification composants (si UI touchée)

Si la tâche touche des composants ou l'UI :
- Lire `design-system/component-catalog.md`
- Si un composant existant couvre le besoin : utiliser ou proposer une variante
- Si non : noter explicitement avec justification

### Étape 4 — Vérification duplication

Avant de proposer une nouvelle fonction, classe ou module : vérifier via Grep/Glob si une implémentation similaire existe.

### Étape 5 — Rédaction exploration.md

Créer `tasks/<slug>/exploration.md` (200 lignes max) :

```markdown
# Exploration — [nom tâche]

## Contexte
[Ce que l'interview a révélé — 3-5 phrases]

## Observations
[Findings codebase — bullet points, ou "aucune exploration codebase effectuée"]

## Questions ouvertes
[Ce qui reste non résolu — bullet points, ou "aucune"]

## Recommandation
[Direction suggérée en 3-5 phrases, auto-suffisante pour le plan]
```

### Étape 6 — Découpage des responsabilités

Définir les responsabilités par fichier avant de rédiger le plan.

Règles :
- Un fichier = une responsabilité principale nommable en une phrase.
- Préférer plusieurs petits fichiers cohérents à un fichier omnibus.
- Taille cible d'un nouveau fichier : 30 à 80 lignes.
- Au-delà de 150 lignes prévues : justifier pourquoi la responsabilité reste unique.
- Ne pas prévoir de fichier `utils`, `helpers` ou `common` sans thème précis.

### Étape 7 — Rédaction plan.md

Créer `tasks/<slug>/plan.md` (100 lignes max). Auto-suffisant — ne suppose pas que `exploration.md` sera relu.

```markdown
# Plan — [nom tâche]

## Décision
[Approche choisie — 2-3 phrases]

## Composants existants réutilisés
[Liste ou "aucun"]

## Étapes
1. [étape]
2. [étape]

## Découpage des responsabilités
[fichier] — [responsabilité] — [taille attendue ou justification]

## Fichiers impactés
[Liste]

## Risques
[Liste ou "aucun"]
```

### Étape 8 — Validation humaine

Soumettre le plan à l'humain. Attendre approbation explicite. Ne pas implémenter avant validation.

### Étape 9 — Mise à jour roadmap

Après validation : passer la phase de `Analyse` à `Implémentation` dans `roadmap.md`. Renseigner le dossier artefacts si absent.

Ne pas exécuter `skills/phase-implementation.md` dans le même tour. La validation du plan ne vaut pas ordre d'implémenter.

Afficher :
```
Analyse terminée.
Artefacts : tasks/<slug>/exploration.md, tasks/<slug>/plan.md
Prochaine phase : Implémentation
En attente d'une demande explicite pour démarrer l'Implémentation.
```
