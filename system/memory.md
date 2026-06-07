# Memory

Ce fichier est le journal de bord du projet. Il enregistre les décisions, trade-offs et contexte important pris au fil des sessions.

Règles d'écriture :
- Seuls les agents écrivent dans ce fichier, jamais l'humain directement.
- Les entrées sont ajoutées en haut du log (la plus récente en premier).
- Ne jamais modifier ou supprimer une entrée existante.

Ce fichier est alimenté à deux moments précis :

**1. En cours de session** — via le skill `update-system.md`, automatiquement déclenché après chaque décision humaine à impact long terme.

**2. En fin de session** — par l'agent en cours, dans la phase de clôture du protocole AGENTS.md. Si des choix significatifs ont été faits pendant la session sans avoir déclenché `update-system.md`, l'agent les consigne ici avant le commit Git.

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
