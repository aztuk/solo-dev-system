# Access Control

Ce fichier définit, pour chaque fichier du projet, qui est autorisé à le lire et à l'écrire, et par quel point d'entrée.

L'orchestrateur (AGENTS.md) consulte ce fichier avant chaque délégation à un skill. Si le skill appelé ne correspond pas à l'éditeur autorisé pour les fichiers qu'il va toucher, l'orchestrateur **bloque l'action et notifie l'humain**.

Format de notification en cas de mismatch :
```
⚠️ Mismatch access-control détecté
Fichier cible    : [fichier]
Éditeur attendu  : [skill ou agent autorisé]
Éditeur réel     : [skill ou agent qui tente l'écriture]
Action           : bloqué — attente de validation humaine
```

Toute modification de ce fichier passe par le skill `update-system.md`.

---

## Légende

- **Lecture** : `Tout agent` = n'importe quel agent peut lire | `Humain` = lecture humaine uniquement
- **Écriture** : le skill ou l'acteur autorisé à modifier ce fichier
- **Point d'entrée** : comment la modification doit être déclenchée

---

## Fichiers système

| Fichier | Lecture | Écriture autorisée | Point d'entrée |
|---|---|---|---|
| `system/governance.md` | Tout agent | `update-system.md` | Décision humaine validée |
| `system/tokens.md` | Tout agent | `figma-sync.md` | Sync depuis page Tokens Figma |
| `system/memory.md` | Tout agent | Agent en session | Fin de session ou via `update-system.md` |
| `system/access-control.md` | Tout agent | `update-system.md` | Décision humaine validée |
| `later.md` | Tout agent | `update-system.md` | Décision humaine validée |

---

## Fichiers d'orchestration

| Fichier | Lecture | Écriture autorisée | Point d'entrée |
|---|---|---|---|
| `AGENTS.md` | Tout agent | `update-system.md` | Décision humaine validée |
| `CLAUDE.md` | Tout agent | `update-system.md` | Décision humaine validée |
| `.cursor/rules/protocol.mdc` | Tout agent | `update-system.md` | Décision humaine validée |
| `TODO.md` | Tout agent | Humain uniquement | Saisie directe humaine |
| `roadmap.md` | Tout agent | Agent en session | Sync depuis `TODO.md` (début session) ou clôture de tâche |

---

## Fichiers design system

| Fichier | Lecture | Écriture autorisée | Point d'entrée |
|---|---|---|---|
| `design-system/component-catalog.md` | Tout agent | `design-audit.md` | Création ou mise à jour composant |
| `design-system/flows-catalog.md` | Tout agent | `figma-sync.md` ou `update-system.md` | Sync Figma ou décision humaine |
| `design-system/components/*.md` | Tout agent | `design-audit.md` | Création ou mise à jour composant |
| `design-system/flows/*.md` | Tout agent | `figma-sync.md` ou `update-system.md` | Sync Figma ou décision humaine |

---

## Skills

| Fichier | Lecture | Écriture autorisée | Point d'entrée |
|---|---|---|---|
| `skills/*.md` | Tout agent | `update-system.md` ou `create-skill.md` | Décision humaine validée |

---

## Fichiers de code applicatif

| Fichier | Lecture | Écriture autorisée | Point d'entrée |
|---|---|---|---|
| `src/**/*` | Tout agent | Agent en session | Tâche validée par l'humain dans `roadmap.md` |
