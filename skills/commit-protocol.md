# Skill — commit-protocol

## Déclencheur

Exécuté par AGENTS.md uniquement quand l'option `5 Commit` de la Review à la carte est sélectionnée.

Ne jamais committer sans compliance validée (`PASSÉ`) dans la review courante ou explicitement confirmée par l'humain.

Les tests unitaires et tests manuels sont pris en compte s'ils ont été sélectionnés ou demandés pendant la review. Ne pas les lancer implicitement.

---

## Protocole

### Étape 1 — Vérification finale

Avant de toucher Git, vérifier :
- Aucun fichier système (`system/`, `AGENTS.md`, `CLAUDE.md`, `design-system/`) n'a été modifié sans passer par le skill approprié
- Aucune variable d'environnement ou clé API présente dans les fichiers stagés
- Aucun fichier `.env` dans le périmètre du commit

Si l'un de ces points échoue → bloquer et notifier l'humain immédiatement.

---

### Étape 2 — Stager les fichiers

Stager uniquement les fichiers du périmètre de la tâche — jamais `git add .` ou `git add -A`.

Afficher la liste des fichiers qui seront commités et attendre confirmation de l'humain.

---

### Étape 3 — Message de commit

Format obligatoire (Conventional Commits) :

```
[type]([scope]): [description courte en français]
```

Limite obligatoire : 20 mots maximum pour tout le message de commit.

Règles :
- Message sur une seule ligne.
- Pas de corps de commit, sauf demande humaine explicite.
- Description courte, concrète, sans justification ni résumé détaillé.
- Si le message proposé dépasse 20 mots : le raccourcir avant validation humaine.

Types :
- `feat` — nouvelle feature ou fonctionnalité
- `fix` — correction de bug
- `chore` — infra, config, dépendances
- `design` — mise à jour design system, tokens, composants
- `data` — schéma BDD, migrations
- `refactor` — restructuration sans changement de comportement

Proposer le message à l'humain avant de committer. Attendre validation.

---

### Étape 4 — Commit

Créer le commit avec le message validé.

Ne jamais pousser vers le remote sans instruction explicite de l'humain.

---

### Étape 5 — Archive artefacts + mise à jour roadmap

Si la session est liée à une tâche avec artefacts dans `tasks/<slug>/` :
- Vérifier que les fichiers `tasks/<slug>/` sont inclus dans les fichiers stagés
- Mettre à jour `roadmap.md` : passer la phase de la tâche à `fait`

Si la session était une exception urgente hors roadmap : ajouter la tâche dans `roadmap.md` avec phase `fait`, sauf dispense explicite de l'humain.

Après toute mise à jour de phase vers `fait` : déplacer la ligne de la section `## En cours` vers la section `## Fait` (format réduit : ID | Tâche | Dossier, sans Pipeline/Modèle/Priorité).

---

### Étape 6 — Handoff synchronisation TODO → roadmap.md

Ne pas exécuter `skills/sync-todo.md` depuis ce skill. Rendre la main à AGENTS.md, qui orchestre `skills/sync-todo.md` après commit.

---

### Étape 7 — Évaluation memory.md

Après le commit, évaluer activement.

Se poser les questions suivantes sur la session qui vient de se terminer :
- Une décision d'architecture ou de design a-t-elle été prise ?
- Un trade-off a-t-il été accepté (ex : dette technique, exception temporaire) ?
- Un problème inattendu a-t-il été rencontré et résolu d'une façon notable ?
- Une règle de gouvernance a-t-elle été créée ou modifiée ?
- Une librairie externe a-t-elle été ajoutée ou refusée, et pourquoi ?

**Si au moins une réponse est oui** → ajouter une entrée dans `system/memory.md`, sauf dispense explicite de l'humain pour cette session.
**Si toutes les réponses sont non** → ne rien écrire, mais avoir évalué explicitement.

---

### Étape 8 — Clôture de session

1. Supprimer le fichier `system/.session-state/<id>.md` de cette session.
2. Afficher le résumé de fin de session et s'arrêter :

```
Session terminée.

Tâche complétée  : [description]
Commit           : [hash court] — [message]
Roadmap          : [mise à jour / dispensée / N/A]
Memory.md        : [mis à jour — sujet] / [rien à logger]
```

Ne pas proposer de tâche suivante. Ne pas demander si l'humain veut continuer. Attendre.

Si l'humain répond dans la même conversation, reprendre le protocole à partir de la Phase 2 de AGENTS.md — ne pas relancer `session-start.md` qui a déjà été exécuté dans cette session.
