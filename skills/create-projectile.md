# Skill — create-projectile

## Déclencheur

Demande utilisateur visant à créer, ajouter ou configurer un type de projectile pour le jeu.

Exemples :
- "crée un projectile perforant qui traverse les ennemis"
- "ajoute un tir chargé plus puissant mais plus lent"
- "configure un projectile explosif avec zone d'impact"

Ce skill traite un type de projectile à la fois.

---

## Entrée

- Intention utilisateur : nom, comportement, stats, visuel.
- Contexte codebase : `src/config/cannonTypes.config.js` (gameplay du tir, T-067), `src/config/projectileTypes.config.js` (catalogue visuel uniquement), `src/entities/Projectile.js`, `src/scenes/PlayScene.js`, `src/systems/CannonSystem.js`.

Depuis T-067, les stats gameplay du tir (`damage`, `speed`, `behavior`) ne vivent plus dans `projectileTypes.config.js` : elles sont portées par le bloc `projectile` du canon qui tire (`CANNON_TYPES[].projectile`). `projectileTypes.config.js` ne reste qu'un catalogue visuel (`id`, `drawIcon`).

## Sortie

- Une entrée visuelle ajoutée à `src/config/projectileTypes.config.js` (`id`, `drawIcon`) si un nouvel `id`/icône est nécessaire.
- Le bloc `projectile` correspondant ajouté/édité côté `CANNON_TYPES` (via `create-cannon.md` si c'est un nouveau canon, ou édition directe si c'est un canon existant).
- Extension de `Projectile.js` uniquement si un état par instance est requis au-delà de `behavior`.
- Tests unitaires pour toute logique pure ajoutée.

---

## Protocole

### 1. Auditer les types existants

Lire `src/config/projectileTypes.config.js` et construire une matrice :

| Type | Rôle | Dommage | Cooldown | Vitesse | Différenciateur |
|---|---|---|---|---|---|

Évaluer le nouveau type :
- Quelle mécanique nouvelle apporte-t-il au gameplay ?
- Est-il lisible visuellement via `drawIcon` en moins d'une seconde ?
- A-t-il un contre-jeu ou une condition d'usage distincte ?

Si la demande décrit surtout une variante numérique, proposer une différence comportementale.

### 2. Qualifier le type

Identifier avant d'écrire :
- `id` : kebab-case unique, partagé entre l'entrée visuelle (`projectileTypes.config.js`) et le bloc `projectile` du canon (`cannonTypes.config.js`).
- `damage`, `speed`, `behavior` : portés par `CANNON_TYPES[].projectile`, pas par `projectileTypes.config.js`.
- `drawIcon(g, cx, cy, radius)` : fonction qui dessine l'icône HUD via Phaser Graphics.

### 3. Ajouter à la config

Ajouter l'entrée visuelle dans `PROJECTILE_TYPES` de `src/config/projectileTypes.config.js` :

```js
{
  id: "pierce",
  drawIcon(g, cx, cy, radius) {
    g.lineStyle(2, GAME_COLORS.ink, 1);
    g.beginPath();
    g.moveTo(cx - radius, cy);
    g.lineTo(cx + radius, cy);
    g.strokePath();
  },
},
```

Puis ajouter/éditer le bloc gameplay côté canon dans `cannonTypes.config.js` :

```js
projectile: { id: "pierce", damage: 2, speed: 700, behavior: { kind: "single" } },
```

Règles :
- Pas de valeur visuelle hardcodée — utiliser `GAME_COLORS`.
- `drawIcon` est la seule logique dans `projectileTypes.config.js`.
- `PROJECTILE_TYPE_MAP` est mis à jour automatiquement (généré depuis le tableau) mais ne sert plus qu'au visuel HUD.
- Ne jamais réintroduire `damage`/`speed`/`behavior` dans `projectileTypes.config.js` : ce fichier ne doit pas redevenir source de vérité gameplay.

### 4. Étendre Projectile.js si nécessaire

Reutiliser `Projectile` si le comportement ne nécessite que des stats différentes.

Étendre uniquement si au moins un point est vrai :
- état propre au tir : perçage, rebond, split, explosion différée ;
- trajectoire impossible via velocityX/velocityY constants ;
- rendu nécessite des données persistantes par instance.

Toute classe compatible avec `ObjectPool` doit exposer `reset(...args)` et `deactivate()`.

### 5. Sélectionner le type actif dans PlayScene / CannonSystem

Lire le bloc `projectile` depuis `cannon.type.projectile` et le passer à `acquire()` (voir `CannonSystem.fireAt` et `PlayScene.fireProjectile`) :

```js
const projectile = cannon.type.projectile;
const speed = projectile.speed * cannon.projectileSpeedMultiplier;
this.projectilePool.acquire(
  muzzle.x, muzzle.y,
  direction.x * speed,
  direction.y * speed,
  projectile.id,
  projectile.damage + cannon.damageBonus,
  cannon.id,
  projectile.behavior,
);
```

### 6. Vérifier

```bash
npm test
npm run build
```

Ajouter des tests si :
- une logique de déplacement ou de collision custom est ajoutée à `Projectile` ;
- `ProjectileHudSystem` est étendu avec un nouveau comportement.

Interdiction absolue : ne jamais lancer de serveur dev/preview/local, navigateur, outil browser, Playwright/Cypress/Puppeteer/agent-browser, screenshot, capture Figma, test visuel, E2E ou smoke test navigateur. Toute validation visuelle du projectile ou de son HUD est un test manuel humain.
