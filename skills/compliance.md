# Skill — compliance

## Déclencheur

Exécuté par AGENTS.md après chaque implémentation, avant tout commit. Aucune exception.

---

## Protocole

### Étape 1 — Collecter les fichiers modifiés

Lister tous les fichiers créés ou modifiés pendant la session en cours. C'est le périmètre d'audit.

---

### Étape 2 — Audits

Zéro tolérance : tout écart est `BLOQUANT` et doit être corrigé avant le commit. Il n'existe pas de niveau intermédiaire.

Effectuer les cinq audits dans l'ordre. Pour chaque audit : `PASSÉ` ou liste des écarts bloquants.

#### Audit 1 — Conformité specs

Comparer l'implémentation avec la spec de la feature.
- Chaque fonctionnalité listée dans la spec est-elle implémentée ?
- Les règles métier sont-elles respectées ?
- Les états UI (vide, chargement, erreur, succès) sont-ils tous couverts ?
- Y a-t-il des éléments implémentés explicitement hors scope dans la spec ?

#### Audit 2 — Conformité tokens

Passer en revue chaque valeur visuelle dans les fichiers modifiés.
- Aucune couleur, taille de texte, espacement ou border radius hardcodé ?
- Toutes les classes utilitaires utilisées correspondent à des tokens définis dans `system/tokens.md` ?
- Aucune valeur de style inline dans les composants ?

#### Audit 3 — Conformité gouvernance

Vérifier les conventions de `system/governance.md`.
- Nommage des fichiers, composants, variables, fonctions conforme ?
- Les exceptions temporaires acceptées sont-elles référencées dans `later.md` ?
- Variables d'environnement utilisées correctement (jamais de clé API hardcodée) ?

#### Audit 4 — Conformité composants

Vérifier l'état du catalog.
- Tous les composants créés ou modifiés sont-ils déclarés dans `design-system/component-catalog.md` ?
- Aucun composant duplique un composant existant dans le catalog ?
- Les fichiers `design-system/components/*.md` existent pour chaque nouveau composant ?

#### Audit 5 — Conformité data

Pour les tâches touchant la base de données (passer si aucun fichier data modifié).
- Les noms de tables et colonnes respectent les conventions définies dans `system/governance.md` ?
- Les accès BDD passent par la couche service et non directement depuis les composants ?
- Les règles d'accès sont-elles définies pour les nouvelles tables ?

#### Audit 6 — Tests unitaires

Vérifier que les tests ont bien été écrits et exécutés via `skills/unit-tests.md` avant d'arriver ici.
- Un fichier de test existe pour chaque fichier source créé ou modifié ?
- Les trois catégories sont couvertes : comportement nominal, comportement agent, edge cases ?
- Tous les tests passent (aucun échec, aucun test ignoré sans justification) ?
- Si des cas n'ont pas pu être testés : la raison est documentée dans le rapport `unit-tests` et validée par l'humain ?

---

### Étape 3 — Afficher le rapport dans le chat

Afficher le rapport directement dans la conversation :

```
Compliance — [nom de la feature] — [date]

Audit 1 — Specs        : PASSÉ / [écarts]
Audit 2 — Tokens       : PASSÉ / [écarts]
Audit 3 — Gouvernance  : PASSÉ / [écarts]
Audit 4 — Composants   : PASSÉ / [écarts]
Audit 5 — Data         : PASSÉ / N/A / [écarts]
Audit 6 — Tests        : PASSÉ / [écarts]

Résultat : PRÊT POUR COMMIT / BLOQUÉ ([n] écart(s))
```

Aucun fichier créé. Le rapport vit uniquement dans le chat.

---

### Étape 4 — Corrections bloquantes

Si des écarts sont détectés :
- Les lister précisément à l'humain avec le fichier et la ligne concernés
- Les corriger
- Relancer uniquement l'audit concerné après correction
- Si la correction implique une décision à impact long terme → déclencher `update-system.md` avant de continuer

Logger dans `system/memory.md` tout écart significatif et sa correction.

Ne pas passer à l'étape 5 tant que tous les audits ne sont pas `PASSÉ`.

---

### Étape 5 — Tests manuels

Proposer une liste de tests à effectuer par l'humain :

```
Tests manuels — [nom de la feature]

[ ] [Action concrète] → [Résultat attendu]
[ ] [Action concrète] → [Résultat attendu]
[ ] [Cas limite] → [Résultat attendu]
[ ] [État vide] → [Résultat attendu]
[ ] [État erreur] → [Résultat attendu]
```

Attendre confirmation explicite de l'humain avant d'autoriser le commit.
