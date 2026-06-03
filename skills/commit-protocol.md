# Skill — commit-protocol

## Déclencheur

Exécuté par AGENTS.md uniquement après :
1. Tous les audits compliance sont `PASSÉ`
2. L'humain a confirmé que les tests manuels sont passés

Ne jamais committer sans ces deux conditions remplies.

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

[corps optionnel — contexte ou décisions notables]
```

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

### Étape 5 — Évaluation memory.md (obligatoire)

Après le commit, toujours évaluer activement — ne jamais sauter cette étape.

Se poser les questions suivantes sur la session qui vient de se terminer :
- Une décision d'architecture ou de design a-t-elle été prise ?
- Un trade-off a-t-il été accepté (ex : dette technique, exception temporaire) ?
- Un problème inattendu a-t-il été rencontré et résolu d'une façon notable ?
- Une règle de gouvernance a-t-elle été créée ou modifiée ?
- Une librairie externe a-t-elle été ajoutée ou refusée, et pourquoi ?

**Si au moins une réponse est oui** → ajouter une entrée dans `system/memory.md`.
**Si toutes les réponses sont non** → ne rien écrire, mais avoir évalué explicitement.

---

### Étape 6 — Clôture de session

1. Mettre à jour `roadmap.md` — statut `[ fait ]`, colonne Agent renseignée
2. Afficher le résumé de fin de session et s'arrêter :

```
Session terminée.

Tâche complétée  : [description]
Commit           : [hash court] — [message]
Memory.md        : [mis à jour — sujet] / [rien à logger]
```

Ne pas proposer de tâche suivante. Ne pas demander si l'humain veut continuer. Attendre.

Si l'humain répond dans la même conversation, reprendre le protocole à partir de la Phase 2 de AGENTS.md — ne pas relancer `session-start.md` qui a déjà été exécuté dans cette session.
