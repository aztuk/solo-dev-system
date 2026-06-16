# Skill - create-particle-system

## Declencheur

Demande utilisateur visant a creer, ajouter ou configurer un effet ou systeme de particules Phaser pour le jeu.

Exemples :
- "cree un nouveau systeme de particule pour les impacts"
- "ajoute des particules quand le canon tire"
- "fais un effet loop autour du joueur"
- "cree les particules de mort du joueur"

Le skill traite un effet de particules a la fois. Si la demande couvre plusieurs effets, AGENTS.md relance ce skill une fois par effet.

---

## Entree

- Intention utilisateur : nom de l'effet et moment ou il doit apparaitre.
- Contexte codebase : `package.json`, `src/scenes/PlayScene.js`, `src/pools/ObjectPool.js`, `src/particles/` si present, `src/systems/ParticleSystem.js` si present.
- Contraintes visuelles : texture, vitesse, duree, taille, alpha, quantite, blend mode, comportement one-shot ou loop.

## Sortie

- Un fichier `src/particles/<effect>.config.js` config-first.
- `src/systems/ParticleSystem.js` cree ou etendu si absent/incomplet.
- Wiring minimal dans `src/scenes/PlayScene.js` pour le trigger demande.
- Verification ObjectPool uniquement pour les effets continus (`trigger.type = "loop"`).

---

## Protocole

### 1. Qualifier l'effet

Identifier et noter avant d'ecrire :

- `effectName` : kebab-case pour le fichier, camelCase pour l'export.
- `trigger.type` : `impact`, `fire`, `loop`, `player-death` ou autre nom explicite si la demande l'impose.
- `trigger.event` : evenement code qui declenchera l'effet, par exemple `projectile-hit`, `cannon-fire`, `player-idle-loop`, `player-death`.
- `mode` : `one-shot` pour `impact`, `fire`, `player-death`; `loop` pour un effet continu.
- Parametres Phaser : `texture`, `speed`, `lifespan`, `scale`, `alpha`, `quantity`, `blendMode`, et tout override utile.

Si le nom, le trigger ou le mode ne peuvent pas etre deduits de la demande, poser une question courte avant toute ecriture.

### 2. Verifier les sources locales

Lire :

- `package.json` pour confirmer la version de Phaser utilisee.
- `src/scenes/PlayScene.js` pour trouver le point de wiring.
- `src/pools/ObjectPool.js` pour le protocole `reset(...args)` / `deactivate()`.
- `src/particles/` et `src/systems/ParticleSystem.js` s'ils existent, pour etendre l'existant.

Pour Phaser 4.1.0 dans ce projet, `this.add.particles(x, y, texture, config)` retourne un `Phaser.GameObjects.Particles.ParticleEmitter`. Les one-shots doivent utiliser `emitter.explode(quantity, x, y)`. Les loops doivent utiliser `start()` / `stop()` ou `flow()` selon le besoin.

### 3. Creer la config d'effet

Creer `src/particles/<effect>.config.js` avec un export nomme. La config doit garder tous les parametres visuels de l'effet hors de `PlayScene.js`.

Structure imposee :

```js
export const impactSparkConfig = {
  name: "impact-spark",
  texture: "particle-pixel",
  trigger: {
    type: "impact",
    event: "projectile-hit",
  },
  mode: "one-shot",
  quantity: 8,
  emitter: {
    speed: { min: 80, max: 180 },
    lifespan: 250,
    scale: { start: 1, end: 0 },
    alpha: { start: 1, end: 0 },
    blendMode: "ADD",
    emitting: false,
  },
};
```

Regles :

- Ne pas mettre de logique metier dans la config.
- Ne pas dupliquer un effet existant ; etendre la config existante si le meme effet existe deja.
- Si une couleur ou un tint est necessaire, l'importer depuis la source de tokens/config du jeu, jamais en valeur brute.
- Si la texture n'existe pas encore, ajouter le plus petit point de creation coherent dans le systeme de particules, pas dans chaque trigger.

### 4. Creer ou etendre `ParticleSystem`

Si `src/systems/ParticleSystem.js` n'existe pas, le creer avec une responsabilite unique : enregistrer des configs de particules, posseder les emitters Phaser, et exposer une API stable aux scenes.

API minimale attendue :

```js
const particleSystem = new ParticleSystem(scene, [impactSparkConfig]);

particleSystem.emit("impact-spark", x, y);
particleSystem.startLoop("engine-glow", x, y);
particleSystem.stopLoop("engine-glow");
```

Contraintes :

- Les one-shots reutilisent un emitter par effet et appellent `explode()`.
- Les loops sont des objets long-vivants. Si plusieurs instances simultanees du meme loop sont necessaires, utiliser `ObjectPool` avec des items qui implementent `reset(...args)` et `deactivate()`.
- `ParticleSystem` ne connait pas les regles metier : il expose seulement `emit`, `startLoop`, `stopLoop`, et eventuellement `destroy`.
- Ne pas appeler un autre skill depuis ce skill.

### 5. Wirer le trigger dans `PlayScene`

Ajouter `ParticleSystem` dans `PlayScene` au meme niveau que les autres systemes.

Patterns de wiring :

- `impact` / `projectile-hit` : appeler `particleSystem.emit(effectName, x, y)` dans le callback de collision, avec la position du projectile ou du collidable selon l'effet.
- `fire` / `cannon-fire` : appeler `emit` juste apres l'acquisition du projectile, a la position du muzzle.
- `loop` : appeler `startLoop` au demarrage du comportement, mettre a jour la position si l'effet suit une entite, puis appeler `stopLoop` quand le comportement s'arrete.
- `player-death` : appeler `emit` au moment exact ou l'etat de mort est valide, pas pendant chaque frame.

Garder `PlayScene` comme orchestrateur uniquement : pas de config emitter inline, pas de logique visuelle detaillee.

### 6. Verifier l'integration ObjectPool

Si `mode = "one-shot"` :

- Ne pas ajouter de pool applicatif pour les particules.
- Laisser Phaser gerer le pool interne de particules de l'emitter.

Si `mode = "loop"` :

- Verifier s'il existe une seule instance globale ou plusieurs instances simultanees.
- Une seule instance : emitter long-vivant stocke dans `ParticleSystem`.
- Plusieurs instances : pooler des handles/emitters loop via `ObjectPool`, avec `reset(...args)` pour position/follow/start et `deactivate()` pour stop/hide/release.

### 7. Verifier

Executer au minimum :

```bash
npm test
npm run build
```

Ajouter ou mettre a jour des tests uniquement si une logique pure testable est introduite dans `ParticleSystem` ou autour du pooling. Ne pas lancer de serveur de dev sauf demande explicite.
