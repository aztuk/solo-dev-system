# CLAUDE.md — Instructions spécifiques à Claude Code

Le protocole de session complet est défini dans `AGENTS.md`. Ce fichier contient uniquement les comportements et outils spécifiques à Claude Code.

**Lire `AGENTS.md` en premier. Ce fichier ne remplace pas `AGENTS.md`, il le complète.**

**Quelle que soit la première demande de l'humain, exécuter `skills/session-start.md` avant de répondre ou d'agir — sans exception. Ne relancer `skills/session-start.md` qu'une seule fois par session.**

**IMPORTANT : Claude Code suit le routing par phase, pas une distinction "consultation/implementation".**
- Exécuter uniquement les Étapes 1-2 de `skills/session-start.md` (initialisation + cache minimal)
- **Ne pas** déterminer un "mode" au démarrage
- À la place : quand une tâche est donnée (via `skills/next-task.md` ou directive directe), regarder sa phase dans `roadmap.md` et exécuter le skill de cette phase
- C'est Codex qui orchestre les phases selon le pipeline ; Claude Code suit le même routing

---

## Outils disponibles dans cet environnement

### Figma MCP
Claude Code a accès au serveur MCP Figma. L'utiliser pour :
- Lire les designs, tokens et composants depuis Figma (`get_design_context`, `get_screenshot`)
- Pousser des modifications vers Figma si nécessaire (`use_figma`)
- Synchroniser les tokens et composants lors de l'exécution de `skills/figma-sync.md`

Ne jamais accéder à Figma en dehors du déclencheur défini dans `skills/figma-sync.md` ou d'une instruction explicite de l'humain.

### Système de mémoire
Claude Code dispose d'un système de mémoire persistant dans `~/.claude/projects/`. Il est alimenté automatiquement entre les sessions pour conserver le contexte du projet.

Ce système de mémoire est **complémentaire** à `system/memory.md` :
- `system/memory.md` — décisions et trade-offs du projet, lisible par tous les agents
- Mémoire Claude Code — contexte de collaboration et préférences, spécifique à Claude Code

### Skills Claude Code
Les skills du projet (dans `/skills/`) sont invocables via l'outil Skill. Toujours passer par cet outil pour exécuter un skill plutôt que de reproduire son contenu manuellement.

---

## Comportements spécifiques

### Réponses
- Réponses courtes et directes. Pas de récapitulatif en fin de réponse.
- Pas d'émojis sauf demande explicite.
- Références aux fichiers toujours en format lien markdown cliquable : `[fichier.md](chemin/fichier.md)`.

### Fichiers
- Toujours lire un fichier avant de l'éditer.
- Préférer `Edit` à `Write` pour les modifications partielles.
- Ne jamais créer de fichier de documentation non demandé.

### Décisions
- Appliquer strictement la règle de `AGENTS.md` : aucune décision produit, architecture ou gouvernance sans validation humaine.
- En cas de doute sur l'autorisation d'écriture d'un fichier, consulter `system/access-control.md` avant d'agir.

### Git
- Ne jamais committer sans instruction explicite de l'humain.
- Ne jamais pousser vers le remote sans confirmation.
- Toujours suivre `skills/commit-protocol.md` pour la structure des messages de commit.
