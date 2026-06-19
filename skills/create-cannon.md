# Skill — create-cannon

## Declencheur

Demande utilisateur visant a creer, ajouter ou configurer un type de canon (secondaire ou de base) pour le jeu.

Exemples :
- "cree un nouveau type de canon qui tire plus lentement mais plus fort"
- "ajoute un canon sniper longue portee"
- "remplace le canon auto-turret de test par un vrai type"

Le skill traite un type de canon a la fois.

---

## Entree

- Intention utilisateur : nom, role gameplay, stats, visuel.
- Contexte codebase : `src/config/cannonTypes.config.js`, `src/config/cannonSlots.config.js` (si existant), `src/entities/SecondaryCannon.js`, `src/systems/CannonSystem.js`, `src/systems/CannonHudSystem.js`, `src/config/projectileTypes.config.js`, `src/config/rarity.config.js` (si existant).

## Sortie

- Un court cadrage game design comparant le nouveau canon aux types existants.
- Une entree ajoutee a `CANNON_TYPES` dans `src/config/cannonTypes.config.js`, avec son `statPool`.
- Wiring minimal dans `CannonSystem`/`CANNON_LAYOUT` ou `cannonSlots.config.js` si un systeme de slots existe.
- Tests unitaires pour toute logique pure ajoutee.

---

## Protocole

### 1. Auditer les canons existants comme game designer

Lire `CANNON_TYPES` dans `src/config/cannonTypes.config.js` et construire une matrice avant d'ecrire :

| Canon | Role | Degats/Cadence | Portee | Projectile lie | Differenciateur |
|---|---|---|---|---|---|

Evaluer le nouveau type :
- Quelle nouvelle decision tactique apporte-t-il (portee vs cadence vs degats) ?
- Est-il lisible visuellement via `drawIcon` en moins d'une seconde ?
- Reutilise-t-il un `projectileTypeId` existant ou justifie-t-il un nouveau type de projectile (`create-projectile.md`) ?

Si la demande decrit surtout une variante numerique, proposer une difference de role (portee, cible, cadence/burst).

### 2. Qualifier le canon

Identifier avant d'ecrire :
- `id` : kebab-case unique.
- `radius`, `barrelLength`, `barrelWidth` : dimensions de rendu.
- `respawnCooldown` : secondes avant reactivation apres destruction.
- `fireDelay` (ms), `fireRange` (pixels).
- `projectile` : bloc gameplay du tir porte par le canon (T-067) — `{ id, damage, speed, behavior }`. C'est la source de verite pour le tir de ce canon, pas `projectileTypes.config.js` (catalogue visuel uniquement, `drawIcon`). Creer une entree visuelle via `create-projectile.md` seulement si un nouvel `id`/icone est necessaire.
- `statPool` : liste des stats tirables en carte de level-up pour ce canon (ex: `fireDelay`, `damageBonus`, `fireRange`, `projectileSpeedMultiplier`), avec une table de valeur fixe par tier de rarete (`common`/`rare`/`epic`/`legendary`/`mythic`, voir `src/config/rarity.config.js`). Valeurs fournies par l'humain : si absentes, ecrire des placeholders explicites `TODO_BALANCE` plutot que d'inventer des chiffres.
- `drawIcon(ctx, cx, cy, radius)` : icone HUD/carte, sans valeur visuelle hardcodee (`GAME_COLORS`).

### 3. Ajouter a la config

```js
{
  id: "sniper",
  radius: 9,
  barrelLength: 28,
  barrelWidth: 4,
  respawnCooldown: 6,
  fireDelay: 1400,
  fireRange: 360,
  projectile: { id: "pierce", damage: "TODO_BALANCE", speed: "TODO_BALANCE", behavior: { kind: "single" } },
  color: GAME_COLORS.ink,
  outline: { color: GAME_COLORS.surface, alpha: 1, inactiveAlpha: 0.25, width: 1 },
  statPool: [
    { stat: "damageBonus", valuesByRarity: { common: "TODO_BALANCE", rare: "TODO_BALANCE", epic: "TODO_BALANCE", legendary: "TODO_BALANCE", mythic: "TODO_BALANCE" } },
    { stat: "fireDelay", valuesByRarity: { common: "TODO_BALANCE", rare: "TODO_BALANCE", epic: "TODO_BALANCE", legendary: "TODO_BALANCE", mythic: "TODO_BALANCE" } },
  ],
  drawIcon: drawSniperIcon,
}
```

Regles :
- Toujours inclure `statPool`, meme vide (`[]`) explicitement assume si ce canon n'est pas tirable en carte de level-up.
- Ne pas dupliquer un type existant : si la demande est une variante numerique simple, ajuster le type existant plutot que creer une entree.

### 4. Integrer au slot/layout

- Si `src/config/cannonSlots.config.js` existe : ajouter le type a la liste des types disponibles pour ce slot, ne pas l'activer par defaut s'il doit etre debloque via une carte.
- Sinon : ajouter une entree a `CANNON_LAYOUT` (`src/config/cannonTypes.config.js`) avec son `offsetX`/`offsetY`.
- Ne pas modifier `SecondaryCannon`/`CannonSystem` pour un besoin propre a un type — passer par les champs de config existants (`damageMultiplier`, `fireRateMultiplier`, `type.*`).

### 5. Verifier

```bash
npm test
npm run build
```

Ajouter des tests si une logique de tir, de ciblage ou de slot custom est ajoutee.

Interdiction absolue : ne jamais lancer de serveur dev/preview/local, navigateur, outil browser, Playwright/Cypress/Puppeteer/agent-browser, screenshot, capture Figma, test visuel, E2E ou smoke test navigateur. Toute validation visuelle du canon ou de son HUD est un test manuel humain.
