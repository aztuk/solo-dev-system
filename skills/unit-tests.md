# Skill — unit-tests

## Déclencheur

Option 2 de la Review à la carte, exécutée par AGENTS.md uniquement si l'humain sélectionne `2`.

Si seuls des fichiers de documentation, protocole, gouvernance ou orchestration Markdown ont changé, les tests unitaires sont `N/A`. L'agent le signale dans le chat et passe au compliance.

---

## Garde-fou Codex — tests autorisés uniquement

Si l'agent en cours est Codex, ce skill est strictement limité aux tests unitaires non interactifs.

Interdictions absolues, sauf demande explicite de l'humain dans le message courant :
- Ne jamais lancer de serveur de développement (`npm run dev`, `next dev`, `vite --host`, etc.).
- Ne jamais ouvrir de navigateur, utiliser Playwright/Cypress/Puppeteer/agent-browser, ni automatiser une navigation.
- Ne jamais prendre de screenshot.
- Ne jamais exécuter de test visuel, E2E, smoke test navigateur ou vérification de rendu par serveur local.

La commande exécutée doit terminer seule et couvrir uniquement la suite unitaire (`vitest run`, `jest`, `pytest`, `go test ./...`, etc.). Si la seule commande disponible lance un serveur, un navigateur ou une suite visuelle/E2E, ne pas l'exécuter : signaler le blocage à l'humain et demander une commande de tests unitaires adaptée.

Si une vérification visuelle semble utile, la noter pour la liste de tests manuels du compliance au lieu de l'exécuter.

---

## Protocole

### Étape 1 — Identifier les cas à tester

À partir des fichiers modifiés pendant la session, lister les cas à couvrir selon trois catégories :

**Comportement nominal (skill)**
- Chaque fonction ou composant produit le bon output pour un input valide
- Les états UI (chargement, succès, vide) s'affichent correctement

**Comportement agent**
- Les appels de services / hooks retournent les bonnes données
- Les effets de bord (mutations, navigation, side-effects) se déclenchent dans les bons cas

**Edge cases**
- Input vide, nul ou invalide
- Erreur réseau ou erreur serveur
- Limites : valeurs min/max, chaînes longues, listes vides
- Comportement si l'utilisateur est non authentifié ou sans permission

---

### Étape 2 — Écrire les tests

Règles :
- Un test = un seul comportement vérifié. Pas de test multi-assertions sans lien logique.
- Les tests doivent être indépendants : aucun test ne doit dépendre de l'état laissé par un autre.
- Nommer chaque test de façon explicite : `[unité] — [condition] → [résultat attendu]`
- Ne pas tester les librairies externes, uniquement le code du projet.
- Si la stack du projet impose un framework de test (défini dans `system/governance.md`), l'utiliser. Sinon, signaler l'absence de convention et demander à l'humain.

Emplacement des fichiers de test : suivre la convention définie dans `system/governance.md`. En l'absence de convention, co-localiser le fichier de test avec le fichier source (`NomFichier.test.[ext]`).

---

### Étape 3 — Lancer les tests

Exécuter la commande de test définie dans `system/governance.md`.

Si aucune commande n'est définie, utiliser la commande standard du framework détecté (`npm test`, `pytest`, `go test ./...`, etc.) et signaler l'absence de convention à l'humain.

Pour Codex, vérifier avant exécution que la commande ne lance ni serveur, ni navigateur, ni test visuel/E2E. En cas de doute, ne pas exécuter la commande et demander confirmation à l'humain.

---

### Étape 4 — Rapport dans le chat

Afficher le résultat directement dans la conversation :

```
Tests unitaires — [nom de la feature] — [date]

Cas couverts :
  Nominal    : [n] tests
  Agent      : [n] tests
  Edge cases : [n] tests

Résultat : [n] passés / [n] échoués / [n] ignorés

[Si échecs] :
  ÉCHEC : [nom du test] — [message d'erreur court]
```

---

### Étape 5 — Traitement des échecs

Si des tests échouent :
- Corriger l'implémentation ou le test selon l'origine du problème
- Relancer les tests après correction
- Ne pas passer au compliance tant que tous les tests ne sont pas au vert

Si un test ne peut pas être écrit (dépendance externe non mockable, environnement manquant) : le documenter explicitement dans le rapport avec la raison, et demander à l'humain si on peut continuer malgré l'absence de couverture.
