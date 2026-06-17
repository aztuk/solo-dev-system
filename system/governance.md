# Governance

Ce fichier définit les règles non-négociables du projet. Tout agent doit le consulter avant toute action structurante. Toute modification de ce fichier passe par le skill `update-system.md` après décision explicite de l'humain.

---

## Stack technique

| Couche | Technologie | Raison |
|---|---|---|
| Moteur jeu | Phaser | Framework 2D principal du prototype incremental shooter. |
| Build / dev | Vite | Bundler ESM rapide, deja utilise par le projet. |
| Tests unitaires | Vitest | Compatible avec Vite et les modules ES du projet. |

---

## Regles de tests

- Le framework de tests unitaires est Vitest.
- La commande de test non interactive est `npm test`.
- Les fichiers de test sont co-localises avec le code source sous la forme `NomFichier.test.js`.
- Les tests unitaires ne doivent pas lancer de serveur de developpement, de navigateur, ni de verification visuelle.

---

## Conventions de nommage

| Élément | Convention | Exemple |
|---|---|---|
| Variables / fonctions | camelCase | `userProfile`, `fetchData` |
| Composants | PascalCase | `UserCard`, `FormInput` |
| Fichiers composants | PascalCase | `UserCard.tsx` |
| Fichiers utilitaires / hooks | camelCase | `useUserData.ts`, `formatDate.ts` |
| Dossiers | kebab-case | `user-management/`, `design-system/` |
| Variables d'environnement | SCREAMING_SNAKE_CASE | `API_URL`, `API_KEY` |

---

## Règles de tokens

- Ne jamais hardcoder une valeur de couleur, typographie, espacement ou border radius dans un composant.
- Toutes les valeurs visuelles proviennent de `system/tokens.md` et sont appliquées via les classes du système de styles correspondant.
- Si un token nécessaire n'existe pas, le signaler à l'humain avant de créer quoi que ce soit. Ne pas inventer de valeur.

---

## Règles de composants

- Avant de créer un nouveau composant, vérifier `design-system/component-catalog.md`.
- Si un composant similaire existe, l'utiliser ou proposer une variante plutôt qu'en créer un nouveau.
- Tout nouveau composant doit être déclaré dans `component-catalog.md` et documenté dans `design-system/components/`.

---

## Règles de décision

- Un agent ne prend jamais de décision produit, architecture ou gouvernance seul.
- Face à un choix non couvert par ce fichier, l'agent présente les options à l'humain avec une recommandation, et attend la décision.
- Toute décision à impact long terme déclenche le skill `update-system.md`.
- Les décisions à portée uniquement locale (choix d'implémentation interne sans impact sur les autres fichiers) peuvent être prises par l'agent, notées dans le code via un commentaire court.

---

## Compatibilité multi-outils

`AGENTS.md` est le protocole unique, tool-agnostic. Chaque outil IA dispose d'un fichier adapter court qui pointe vers `AGENTS.md`.

| Outil | Fichier adapter |
|---|---|
| Claude Code | `CLAUDE.md` |
| Codex | `AGENTS.md` (natif) |
| Cursor | `.cursor/rules/protocol.mdc` |
| Windsurf | `.windsurfrules` (à créer si besoin) |
| GitHub Copilot | `.github/copilot-instructions.md` (à créer si besoin) |

**Règle pour tout nouveau développeur rejoignant le projet avec un outil IA :** créer l'adapter correspondant via `update-system.md` avant de commencer. L'adapter ne contient aucune logique — il pointe uniquement vers `AGENTS.md`.

---

## Architecture des agents et skills

**Règle fondamentale : pas d'imbrication au-delà du niveau 2.**

```
Niveau 0 : Humain
Niveau 1 : AGENTS.md (orchestrateur unique)
Niveau 2 : Skills (session-start, compliance, design-audit, etc.)
```

- Seul AGENTS.md appelle des skills. Les skills ne s'appellent jamais entre eux.
- Un skill est une feuille, pas un nœud. Il exécute, il ne délègue pas.
- Toute création de nouveau skill ou agent passe par le skill `create-skill.md`.
- Si une logique semble nécessiter un skill appelant un autre skill, c'est le signe qu'il faut restructurer : soit fusionner les deux, soit remonter l'orchestration dans AGENTS.md.

---

## Scope

### Inclus

*À renseigner lors de la phase de setup du projet.*

### Explicitement exclus

*À renseigner lors de la phase de setup du projet.*

---

## Contrôle d'accès aux fichiers

Avant d'écrire dans n'importe quel fichier du projet, un agent doit consulter `system/access-control.md` et vérifier :
- Qu'il est bien listé comme éditeur autorisé pour ce fichier.
- Que le point d'entrée utilisé (skill ou action directe) correspond à celui défini.

Si l'agent ou le skill appelant ne correspond pas à l'éditeur attendu, **ne pas écrire** et notifier l'humain avec :
- Le fichier concerné
- L'éditeur attendu selon `access-control.md`
- L'éditeur réel qui tente l'écriture

L'orchestrateur (AGENTS.md) applique cette vérification avant chaque délégation à un skill.

---

## Fichiers de référence

| Besoin | Fichier |
|---|---|
| Contexte et trade-offs passés | `system/memory.md` |
| Design tokens | `system/tokens.md` |
| Contrôle d'accès aux fichiers | `system/access-control.md` |
| Composants existants | `design-system/component-catalog.md` |
| Flows et pages | `design-system/flows-catalog.md` |
| Specs features | *(dossier à définir dans le projet)* |
