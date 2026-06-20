# Memory

Ce fichier est le journal de bord du projet. Il enregistre les décisions, trade-offs et contexte important pris au fil des sessions.

Règles d'écriture :
- Seuls les agents écrivent dans ce fichier, jamais l'humain directement.
- Les entrées sont ajoutées en haut du log (la plus récente en premier).
- Ne jamais modifier ou supprimer une entrée existante.

Ce fichier est alimenté à deux moments précis :

**1. En cours de session** — via le skill `update-system.md`, automatiquement déclenché après chaque décision humaine à impact long terme.

**2. En fin de session** — par l'agent en cours, dans la phase de clôture du protocole AGENTS.md. Si des choix significatifs ont été faits pendant la session sans avoir déclenché `update-system.md`, l'agent les consigne ici avant le commit Git.

## 2026-06-20 — T-074 découpée en 3 sous-tâches roadmap (cleanup / split UI-gameplay / harmonisation canon-ennemi)

**Contexte** : T-074 demandait un ménage large des configs canon/projectile/enemy avec séparation gameplay/UI. L'exploration a montré un périmètre trop large pour une implémentation atomique : code mort isolé (`projectileTypes.config.js`, `spawnRateStat.config.js`), un split gameplay/UI à appliquer uniformément sur tous les fichiers de catalogue (cannonTypes + ennemis), et une harmonisation structurelle Canon-vs-Ennemi qui recoupe directement T-056 déjà en roadmap.
**Décision** : garder T-074 comme la sous-tâche 1 (suppression du code mort, terminée et commitée), créer T-076 (split gameplay/UI par fichier `*.ui.js`/`*.config.js`) et T-077 (harmonisation structurelle, à coordonner avec T-056 plutôt que la dupliquer) comme nouvelles entrées roadmap directes, sur demande explicite de l'humain plutôt que via `sync-todo.md` (car décomposition d'une tâche déjà actée, pas une nouvelle demande hors roadmap).
**Alternatives écartées** : tout livrer dans une seule implémentation T-074 (écarté — périmètre trop large, risque de fichier omnibus) ; tracer les sous-tâches uniquement dans `TODO.md` pour repasser par `sync-todo.md` (écarté par l'humain, qui a préféré l'ajout direct en roadmap).
**Impact** : `roadmap.md` (T-074 déplacée en Fait, T-076/T-077 ajoutées en `à faire`), `tasks/t074-cleanup-configs/exploration.md` + `plan.md`, suppression de `src/config/projectileTypes.config.js` et `src/config/spawnRateStat.config.js` (fonction inlinée dans `pointNoir.config.js`/`sprinterEnemy.config.js`). À surveiller : T-077 ne doit pas dupliquer T-056 si celle-ci démarre avant.
**Décidé par** : Humain (validation du plan + découpage), avec exécution Claude Code.

## 2026-06-19 — Pierce sniper data-driven via pierceCount d'instance

**Contexte** : T-054 demandait le projectile perforant (pierce) du sniper. L'humain s'est interrogé sur la scalabilité : faudrait-il recoder pour ajouter le pierce à un autre canon ou à un futur système global ("trésor : tous vos projectiles percent +1") ?
**Décision** : `pierceCount` est un champ d'instance sur `Cannon`/`SecondaryCannon` (défaut `0`, comme `damageBonus`/`fireRateMultiplier`), lu génériquement par `ProjectileCollisionSystem`. Le `statPool` de `cannonTypes.config.js` ne fait que déclarer quelles cartes de draft sont proposées par type (avec gating `minRarity`) — il n'active pas la mécanique. Un système global pourrait incrémenter `pierceCount` sur n'importe quel canon (via `applyStatBonus` ou en bouclant sur les instances) sans toucher au moteur de collision.
**Alternatives écartées** : déclarer une valeur de base `pierceCount` par type dans `cannonTypes.config.js`, écarté car aucun canon n'a besoin aujourd'hui d'un défaut différent de 0 — introduirait une deuxième source de vérité sans bénéfice immédiat.
**Impact** : `src/entities/Projectile.js`, `src/entities/Cannon.js`, `src/entities/SecondaryCannon.js`, `src/systems/CannonSystem.js`, `src/systems/ProjectileCollisionSystem.js`, `src/systems/CardDraftSystem.js` (helper `compareRarity` pour le gating `minRarity`), `src/scenes/PlaySceneDebugHotkeys.js` (nouveau, hotkeys debug extraites de `PlayScene.js` pour respecter le seuil de 250 lignes).
**Décidé par** : Humain (choix de conserver le pattern existant), avec exécution Claude Code.

Format d'une entrée :

```
## [AAAA-MM-JJ] — Titre court de la décision

**Contexte** : pourquoi cette décision s'est posée
**Décision** : ce qui a été choisi
**Alternatives écartées** : ce qui a été rejeté et pourquoi
**Impact** : fichiers modifiés, règles ajoutées
**Décidé par** : Humain / Agent (avec validation humaine)
```

---

## Log

## 2026-06-19 — Interdiction des tests visuels renforcee dans instructions et skills

**Contexte** : l'humain a rappele explicitement "PAS DE VERIFICATION VISUEL" apres une tentative de verification par serveur local/capture. Les garde-fous existaient deja dans plusieurs fichiers mais n'etaient pas assez centraux ni assez explicites contre les fallbacks headless/CLI/browser.
**Decision** : rendre l'interdiction prioritaire et non negociable dans `CLAUDE.md`, `AGENTS.md`, `system/governance.md`, `session-start.md` et les skills de debug, implementation, review, tests, compliance, Figma et creation de contenu. Les validations visuelles doivent toujours etre listees comme tests manuels humains.
**Alternatives ecartees** : conserver uniquement la regle existante dans governance/AGENTS, ecarte car elle n'a pas empeche un fallback visuel ; autoriser des checks headless "non visuels", ecarte car ils contournent l'intention humaine.
**Impact** : interdiction explicite des serveurs dev/preview/local, navigateurs, outils browser, Playwright/Cypress/Puppeteer/agent-browser, screenshots, captures Figma, E2E et smoke tests navigateur pour tout agent du projet.
**Decide par** : Humain, avec execution Codex.

## 2026-06-19 — T-053 : position de tour propre au type (pas au slot), type du canon principal exclu du déblocage secondaire

**Contexte** : exploration.md de T-053 affirmait que `CANNON_TYPES["auto-turret"]` existait déjà ; vérification de tout l'historique git du fichier (4 commits) a montré qu'il n'a jamais contenu que `"sniper"` — l'exploration était inexacte. Par ailleurs, `CANNON_SLOTS` fixait une position (`offsetX`/`offsetY`) par index de slot plutôt que par type : une tour donnée changeait de position selon l'ordre de déblocage. L'humain a aussi précisé en cours d'implémentation que le type choisi en canon principal ne doit jamais réapparaître comme choix de déblocage secondaire, et que certaines tours (sniper) veulent une position absolue depuis le haut de l'écran plutôt que relative au centre.
**Décision** : `auto-turret` recréé via le protocole `create-cannon.md` (valeurs reprises du hardcodé existant, `statPool` à `null` partout — exclu du tirage de cartes tant que l'humain n'a pas fourni de vraies valeurs). Position déplacée de `CANNON_SLOTS` (par slot) vers `CANNON_TYPES` (`offsetX`/`offsetY` relatifs à l'ancre de formation `marginLeft`/hauteur-écran/2, ou `absoluteY` optionnel pour une position fixe depuis le haut). `CannonSystem.getLockedTypeIds()` exclut désormais `this.basicCannon.type.id` du pool de déblocage. Choix du canon de départ persisté en `localStorage` via `CannonSelectionSystem` (nouveau), écran intégré à `#start-screen`.
**Alternatives écartées** : conserver des positions par slot (rejeté par l'humain — la position doit être une propriété intrinsèque de la tour, pas de son ordre de déblocage) ; laisser `auto-turret` avec des valeurs de stats inventées (rejeté — `create-cannon.md` impose `TODO_BALANCE`/placeholders explicites en l'absence de valeurs humaines, donc `null` partout pour exclure ces cartes du tirage plutôt que risquer un bonus `NaN`).
**Impact** : `src/config/cannonTypes.config.js`, `src/config/cannonSlots.config.js` (devient un simple compteur `CANNON_SLOT_COUNT`), `src/config/cannon.config.js`, `src/entities/Cannon.js` (+`reposition()`, +`offsetX/offsetY/absoluteY`), `src/entities/SecondaryCannon.js`, `src/systems/CannonSystem.js`, `src/systems/CannonSelectionSystem.js` (nouveau), `src/scenes/PlayScene.js`, `index.html`, `src/styles.css`. À surveiller : T-055 (canon principal toujours absent des cartes d'amélioration de level-up, limitation distincte non traitée ici) ; T-056 propose d'harmoniser l'archi config canons sur celle des ennemis (un fichier par type).
**Décidé par** : Humain (clarifications ciblées sur l'écart exploration/code, l'exclusion de déblocage, et le positionnement par type), avec exécution Agent.

## 2026-06-19 — T-046 : EnemySpawner généralisé à un pool+timer par type, spawn rate en unité humaine

**Contexte** : `create-enemy.md` n'imposait pas d'artefact d'exploration ni de validation humaine avant code, ce qui a fait sauter l'audit complet à la 1ère tentative. En creusant l'implémentation du Sprinter (1er ennemi avec un comportement custom), découverte que `EnemySpawner` n'avait qu'un seul `ObjectPool` codé en dur sur `Enemy` — un type avec une classe dédiée n'était donc jamais réellement instancié. Question annexe de l'humain sur le malus "spawnrate" a aussi révélé qu'un poids relatif (`spawnWeight`) entre types était illisible (effet en % dépendant du nombre de types actifs).
**Décision** : `create-enemy.md` impose maintenant un `exploration.md` complet (matrice + qualification + sources) validé par l'humain avant tout code. `EnemySpawner` a un `ObjectPool` et un timer Phaser indépendants par type (factory = `config.create`), plus de tirage pondéré partagé. Chaque type déclare `spawnPer5Sec` ("X toutes les 5 secondes", unité humaine) au lieu d'un poids relatif ; les cartes de level-up modifient cette valeur en flat et reschedulent le timer du type immédiatement.
**Alternatives écartées** : garder un seul pool et piloter le comportement custom via un branchement `if` dans `Enemy.update()` selon `config.movement` — écarté par l'humain au profit de la généralisation du spawner, jugée plus scalable pour les futurs ennemis à comportement distinct.
**Impact** : `AgenticSystem/skills/create-enemy.md`, `src/spawner/EnemySpawner.js`, `src/systems/SpawnProgressionSystem.js`, `src/config/pointNoir.config.js` (+`spawnPer5Sec`/`spawnPer5SecMax`, `pointNoirConfig` supprimé), `src/config/enemyTypes.config.js` (nouveau registre central), `src/config/sprinterEnemy.config.js`, `src/entities/Sprinter.js`, `src/systems/EnemySystem.js` (+rendu triangle, configs propagées dans les callbacks mort/spawn/cannon-hit pour un camera-shake par type). roadmap.md/PlayScene.js non commités avec ce changement (édités en parallèle par un autre agent au moment de la session).
**Décidé par** : Humain (choix architecture spawner + unité spawn rate via questions ciblées), avec exécution Agent.

## 2026-06-19 — Bugs level-up : tirage sans doublon, hitbox calculée depuis radius, malus épique forcé sur unlock

**Contexte** : 4 bugs roadmap (tirage CardDraftSystem pouvant proposer 2x la même carte, `hitboxRadius` stocké en dur et désynchronisable de `radius`/`displayRadius`, stats % affichées en décimal brut) + un 5e bug découvert pendant la vérification manuelle : choisir une carte "Nouveau canon" (kind `unlock`, sans `rarity`) forçait `showEnemyCards(undefined)`, donc un malus ennemi à rareté aléatoire au lieu d'épique.
**Décision** : `CardDraftSystem.drawCards()` déduplique par clé `typeId:stat` (Set `usedKeys`), retourne moins de cartes si le pool est épuisé plutôt que des doublons. `Enemy.hitboxRadius`/`radius` deviennent des getters calculés (`displayRadius + config.hitboxMargin`) au lieu de propriétés assignées au constructeur/reset — la carte "Taille" du point noir cible maintenant `radius` (rétrécit aussi le visuel, pas seulement la hitbox invisible). `LevelUpHudSystem` formate les stats marquées `isPercent: true` en `+15%`. `PlayScene.showCannonCards` force `forcedRarity = "epic"` quand `card.kind === "unlock"` (au lieu de `card.rarity ?? null`).
**Alternatives écartées** : hitbox strictement égale au radius affiché sans marge (annule l'intention T-037 de tolérance de collision) ; carte "Taille" gardée sur un champ hitbox séparé (laisse le malus invisible, écarté par l'humain).
**Impact** : `src/systems/CardDraftSystem.js`, `src/systems/CardDraftSystem.test.js`, `src/entities/Enemy.js`, `src/config/pointNoir.config.js` (+`hitboxMargin`, stat renommé `radius`), `src/config/cannonTypes.config.js` (+`isPercent`), `src/systems/LevelUpHudSystem.js`, `src/scenes/PlayScene.js`. roadmap.md non touché dans ce commit (édité en parallèle par un autre agent au moment de la session).
**Décidé par** : Humain (choix de formule hitbox + périmètre des bugs via questions ciblées), avec exécution Agent.

## 2026-06-18 — T-025 : rareté du malus toujours alignée au bonus choisi, pas tirée séparément

**Contexte** : implémentation initiale tirait la rareté de la carte canon (bonus) et celle de la carte ennemi (malus) indépendamment via un même `pickRarity()` pondéré ; l'humain a corrigé en testant que ce n'était pas le comportement voulu (déjà demandé dans le libellé de la tâche : "des valeurs de malus toujours matchées à la rareté sélectionnée sur le bonus").
**Décision** : `CardDraftSystem.drawCards()` accepte un `forcedRarity` optionnel — quand fourni, toutes les cartes upgrade de l'appel utilisent cette rareté au lieu d'en tirer une. `PlayScene` capture `card.rarity` au choix de la carte canon et le repasse à `showEnemyCards(forcedRarity)`.
**Alternatives écartées** : tirage indépendant par écran (implémenté puis rejeté par l'humain, ne correspond pas au libellé de tâche).
**Impact** : `src/systems/CardDraftSystem.js`, `src/scenes/PlayScene.js`. Pendant le diagnostic, l'instrumentation de debug (`window.__debugScene`) et un script Playwright temporaire ont été ajoutés puis retirés — l'humain a rappelé que toute vérification visuelle automatisée est interdite (cf. entrée du jour ci-dessous), seule la vérification par logique pure (sans rendu) est restée.
**Décidé par** : Humain (bug reporté + comportement voulu précisé), avec exécution Agent.

## 2026-06-18 — T-025 : cloner les configs de type par instance de spawner (anti-fuite restart)

**Contexte** : la review de diff a détecté que `EnemySpawner.applyStatBonus`/`unlock` mutaient directement le singleton exporté par `pointNoir.config.js` (`POINT_NOIR`/`ENEMY_TYPE_MAP`) ; comme ce module n'est jamais réimporté, un `scene.restart()` après game over faisait persister les malus ennemi cumulés sur la partie précédente.
**Décision** : `EnemySpawner` clone les configs de type dans `this.typeConfigs` à la construction et à chaque `unlock()`, et `applyStatBonus` mute ce clone plutôt que le singleton. Le canon n'avait pas ce problème (l'instance `SecondaryCannon` est recréée à chaque `create()`).
**Alternatives écartées** : reset explicite du singleton au restart (plus fragile, dépend de ne jamais oublier l'appel) ; figer la config en lecture seule sans clone (empêcherait les malus de fonctionner du tout).
**Impact** : `src/spawner/EnemySpawner.js`. Pattern à reproduire pour tout futur système qui mute un config de type partagé en cours de partie (T-046 ajoutera un 2e type d'ennemi, à vérifier qu'il suit ce pattern).
**Décidé par** : Agent (détecté en review), avec validation humaine.

## 2026-06-18 — Interdiction totale des verifications visuelles automatisees

**Contexte** : l'humain a signale que Codex et Claude Code tentaient trop souvent des verifications visuelles en lancant serveurs, screenshots ou outils navigateur.
**Decision** : interdire a tous les agents toute verification visuelle automatisee : pas de serveur dev/preview/local, pas de navigateur automatise, pas de Playwright/Cypress/Puppeteer/agent-browser, pas de screenshot ou capture Figma pour valider le rendu. Les validations visuelles sont uniquement listees comme tests manuels pour l'humain.
**Alternatives ecartees** : conserver l'exception "sauf demande explicite", ecartee car elle entretenait les ecarts de comportement entre agents.
**Impact** : `AGENTS.md`, `CLAUDE.md`, `system/governance.md`, `skills/unit-tests.md`, `skills/compliance.md`, `skills/phase-implementation.md`, `skills/figma-sync.md`, `skills/create-particle-system.md`.
**Decide par** : Humain, avec execution Codex.

## 2026-06-18 — T-024 : flow level-up bonus/malus en coquille (sans effets réels)

**Contexte** : T-024 demandait XP + courbe de niveau + choix bonus/malus à chaque niveau. Le plan a posé le flow et le contrat d'options sans câbler d'effet de jeu réel (T-025 doit brancher le vrai contenu plus tard).
**Décision** : `LevelSystem` (xp/niveau pur), `LevelUpHudSystem`/`LevelHudSystem` (DOM, overlays bonus→malus séquentiels + barre de niveau pleine largeur), options placeholder dans `levelUpChoices.config.js` sans logique d'application. `PlayScene.js` orchestre pause/reprise (passe de 325 à 368 lignes, déjà au-dessus du seuil 250 avant cette tâche — extraction trackée séparément en T-048, pas de refactor inclus ici).
**Alternatives écartées** : câbler un vrai effet (dégât/spawn) dès maintenant — écarté, hors scope demandé ("Explorer en profondeur" mais pas "implémenter les effets") ; extraire PlayScene avant d'ajouter la logique — écarté car déjà une tâche dédiée (T-048).
**Impact** : `src/config/level.config.js`, `src/config/levelUpChoices.config.js`, `src/systems/LevelSystem.js`, `src/systems/LevelUpHudSystem.js`, `src/systems/LevelHudSystem.js`, `src/scenes/PlayScene.js`, `index.html`, `src/styles.css`, sons `level-up`. À surveiller : T-048 doit se faire avant que PlayScene continue de grossir.
**Décidé par** : Humain (plan validé), avec exécution Agent.

## 2026-06-17 — SpawnProgressionSystem : registre centralisé de mutation du spawn rate

**Contexte** : T-029 demandait un mécanisme pour rendre le taux de spawn mutable par ennemi, en vue d'être piloté par T-024 (level-up roguelike).
**Décision** : créer `SpawnProgressionSystem` comme registre clé→{spawner, currentRate, config}. Chaque config d'ennemi déclare `spawnRateMax` et `spawnIncrement`. L'incrément time-based a été écarté.
**Alternatives écartées** : incrément automatique toutes les X secondes (écarté car T-024 doit contrôler le timing des malus) ; muter directement le spawner depuis PlayScene (écarté car logique dispersée sans cap centralisé).
**Impact** : `src/systems/SpawnProgressionSystem.js` (nouveau), `src/spawner/EnemySpawner.js` (+setSpawnRate), `src/config/pointNoir.config.js` (+spawnRateMax/spawnIncrement). T-024 appellera `scene.spawnProgressionSystem.incrementSpawnRate("pointNoir")` à chaque level-up.
**Décidé par** : Humain, avec exécution Agent.

## 2026-06-17 — Vitest v4 : bug multi-fichiers résolu par singleFork

**Contexte** : en passant à 2 fichiers de test (`ObjectPool.test.js` + `ParticleSystem.test.js`), Vitest v4.1.9 échouait avec `Cannot read properties of undefined (reading 'config')` au lancement des deux suites simultanément. Chaque fichier passait seul.
**Décision** : créer `vite.config.js` avec `test.pool = "forks"` et `forks.singleFork = true` pour forcer l'exécution séquentielle dans un même processus.
**Alternatives écartées** : `pool: "threads"` (même problème) ; ignorer le bug (masque les régressions futures).
**Impact** : `vite.config.js` (nouveau). À surveiller si Vitest sort un correctif dans une prochaine version.
**Décidé par** : Agent, avec validation humaine.

## 2026-06-17 — gameConfig inliné dans main.js pour casser la dépendance circulaire

**Contexte** : T-020 déplaçait `gameConfig` dans `src/config/game.config.js`, qui importait `PlayScene`. Or `PlayScene` importe `game.config.js` → dépendance circulaire → `GAME_COLORS` non initialisé au moment de l'import.
**Décision** : `game.config.js` n'exporte que `GAME_COLORS`. `gameConfig` est inliné dans `main.js`, qui est le seul consommateur et le point d'entrée naturel pour la config Phaser.
**Alternatives écartées** : fichier séparé `phaser.config.js` (inutile pour un seul usage) ; re-export depuis un index (ajoute de l'indirection sans bénéfice).
**Impact** : `src/config/game.config.js`, `src/main.js`. Règle à retenir : tout fichier de config qui importe une entité Phaser crée un risque de cycle — préférer l'injection au point d'entrée.
**Décidé par** : Agent, avec validation humaine.

## 2026-06-16 - Skill de creation de systemes de particules

**Contexte** : T-012 demandait un skill AgenticSystem pour guider la creation d'effets de particules Phaser, avec un routage explicite depuis les demandes utilisateur comme "cree un nouveau systeme de particule pour xxx".
**Decision** : creer `skills/create-particle-system.md` comme skill autonome config-first et ajouter dans `AGENTS.md` un routing par demande utilisateur vers ce skill.
**Alternatives ecartees** : mettre les instructions directement dans `AGENTS.md`, ecarte pour garder l'orchestrateur lisible ; faire appeler d'autres skills depuis le nouveau skill, ecarte pour respecter la regle d'imbrication.
**Impact** : `AgenticSystem/skills/create-particle-system.md`, `AgenticSystem/AGENTS.md`, `AgenticSystem/system/memory.md`.
**Decide par** : Humain, avec execution Codex.

## 2026-06-16 — Bridge tokens JS → CSS via variables CSS custom properties

**Contexte** : le HUD HTML utilise `color: #000000` hardcodé, alors que `GAME_COLORS.ink` existe dans `config.js`. Le CSS ne peut pas importer du JS directement.
**Décision** : ajouter `inkCss` dans `GAME_COLORS` et l'injecter via `document.documentElement.style.setProperty("--color-ink", ...)` au `create()` de PlayScene. Le CSS référence `var(--color-ink)`.
**Alternatives écartées** : style inline sur l'élément HUD (moins maintenable) ; dupliquer la valeur sans lien (violation de la règle tokens).
**Impact** : `src/game/config.js`, `src/styles.css`, `src/scenes/PlayScene.js`. Pattern à reproduire pour tout futur élément HTML qui doit référencer une couleur du jeu.
**Décidé par** : Agent, avec validation humaine.

## 2026-06-16 — Framework de tests unitaires

**Contexte** : l'humain a demande d'ajouter un framework de test et de consigner la convention dans governance.
**Decision** : utiliser Vitest comme framework de tests unitaires, avec `npm test` pour la commande non interactive et des fichiers `*.test.js` co-localises avec le code source.
**Alternatives ecartees** : Jest, ecarte car Vitest s'integre plus directement a Vite et aux modules ES du projet.
**Impact** : `package.json`, `package-lock.json`, `src/pools/ObjectPool.test.js`, `system/governance.md`, `system/memory.md`.
**Decide par** : Humain, avec execution Codex.

## 2026-06-16 — Séparation EnemySpawner / EnemySystem

**Contexte** : T-005 demandait un spawner générique réutilisable pour tous les types d'ennemis futurs. L'ancien EnemySystem gérait pool + spawn + logique métier dans un seul fichier.
**Décision** : séparer en deux responsabilités — `EnemySpawner` (lifecycle : pool ObjectPool + timer Phaser + position de spawn) et `EnemySystem` (logique métier : update, draw, damage). PlayScene orchestre les deux.
**Alternatives écartées** : garder EnemySystem monolithique avec un paramètre config, rejeté car le timer et la position de spawn appartiennent au cycle de vie, pas à la logique métier ; faire gérer le timer par PlayScene, rejeté car chaque type d'ennemi aurait un timer différent.
**Impact** : `src/spawner/EnemySpawner.js` (nouveau), `src/enemies/pointNoir.config.js` (pattern config par ennemi), `src/systems/EnemySystem.js` (refactorisé), `src/scenes/PlayScene.js`. Pattern à reproduire pour T-013 (skill création ennemi).
**Décidé par** : Agent, avec validation humaine.

## 2026-06-07 — Grill-me avant Exploration

**Contexte** : l'humain a testé la phase Exploration sur un autre projet et l'a trouvée trop checklistée ; il veut intégrer un vrai comportement `grill-me.md`, connu dans l'écosystème des agent skills, puis propager le système vers `SpaceExploration`.
**Décision** : créer `skills/grill-me.md` comme skill autonome d'interview, l'orchestrer dans `AGENTS.md` avant `skills/phase-exploration.md`, et recentrer `phase-exploration.md` sur la consolidation du handoff et la rédaction de `exploration.md`.
**Alternatives écartées** : laisser l'interview codée directement dans `phase-exploration.md`, rejeté car trop rigide ; faire appeler `grill-me.md` par `phase-exploration.md`, rejeté pour respecter la règle "les skills ne s'appellent jamais entre eux".
**Impact** : `AGENTS.md`, `skills/grill-me.md`, `skills/phase-exploration.md`, `system/memory.md`. La même modification a été appliquée dans `SpaceExploration` pour garder les protocoles symétriques.
**Décidé par** : Humain, avec exécution Codex.

## 2026-06-06 — Rapport de contexte en fin de session

**Contexte** : l'humain veut voir, en fin de session, où le contexte/tokens a été le plus consommé : moment, fichiers, skills et actions.
**Décision** : ajouter un `Context usage log` approximatif dans le session-state et produire en Phase 7 un rapport de session basé sur ce journal.
**Alternatives écartées** : instrumentation précise des tokens par appel modèle, jugée plus lourde et reportée ; l'option retenue privilégie une estimation exploitable `XS/S/M/L/XL`.
**Impact** : `AGENTS.md`, `skills/session-start.md`, `system/memory.md`. La même modification a été appliquée dans `SpaceExploration` pour garder les protocoles symétriques.
**Décidé par** : Humain, avec exécution Codex.

## 2026-06-05 — Garde-fous d'implémentation

**Contexte** : la Phase 5 manquait de règles explicites pour éviter les fichiers trop gros, la duplication de logique et la création excessive de fichiers.
**Décision** : créer `skills/implementation-guardrails.md` et l'appeler en Phase 5 uniquement quand du code doit être écrit ou modifié.
**Alternatives écartées** : intégrer toutes les règles directement dans `AGENTS.md`, rejeté pour garder l'orchestrateur lisible ; utiliser un agent externe générique, rejeté pour préserver l'architecture locale sans imbrication.
**Impact** : `AGENTS.md`, `skills/implementation-guardrails.md`, `system/memory.md`.
**Décidé par** : Humain, avec exécution Codex.
