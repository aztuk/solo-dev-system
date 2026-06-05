# AGENTS.md — Orchestrateur

Ce fichier définit le protocole de session commun à tous les agents (Claude Code, Codex). Chaque session, quel que soit l'agent utilisé, suit exactement ce protocole dans l'ordre défini.

**Position dans la hiérarchie :**
```
Niveau 0 : Humain
Niveau 1 : AGENTS.md  ←  tu es ici
Niveau 2 : Skills
```

Règle absolue : AGENTS.md est le seul orchestrateur. Les skills ne s'appellent jamais entre eux.

---

## RÈGLE D'ENTRÉE — À appliquer avant tout

**Quelle que soit la première demande de l'humain** — une question, une instruction, une tâche, n'importe quoi — exécuter `skills/session-start.md` en premier si ce n'est pas déjà fait dans cette session.

Ne jamais répondre directement à une demande sans avoir d'abord complété `session-start.md`.

La seule exception : si `session-start.md` a déjà été exécuté plus tôt dans cette même session, ne pas le relancer.

Si l'humain pose une question simple (consultation, pas d'implémentation), exécuter quand même `session-start.md` puis répondre à la question.

---

## Fichiers à lire avant toute action

Au démarrage de chaque session, lire dans cet ordre :
1. `system/governance.md` — règles non-négociables
2. `system/access-control.md` — autorisations d'écriture par fichier
3. `system/memory.md` — contexte et décisions passées
4. `system/tokens.md` — tokens disponibles

---

## Skills disponibles

| Skill | Déclencheur |
|---|---|
| `skills/session-start.md` | Début de chaque session |
| `skills/product-challenge.md` | Après classification, pour toute tâche M+ (Dev, Design, Produit) |
| `skills/design-audit.md` | Avant toute création ou modification de composant ou valeur visuelle |
| `skills/scaffold-feature.md` | Lancement d'une nouvelle feature Dev validée |
| `skills/unit-tests.md` | Après chaque implémentation (Phase 5), avant compliance |
| `skills/compliance.md` | Après chaque implémentation et tests unitaires validés, avant commit |
| `skills/figma-sync.md` | Après mise à jour de la page Tokens ou composants dans Figma |
| `skills/commit-protocol.md` | Après validation humaine du compliance |
| `skills/update-system.md` | Après chaque décision humaine à impact long terme |
| `skills/create-skill.md` | Quand une décision humaine implique la création d'un nouveau skill |

---

## Validation access-control

Avant chaque délégation à un skill, vérifier dans `system/access-control.md` :
- Le skill appelé est-il bien l'éditeur autorisé pour les fichiers qu'il va modifier ?
- Le point d'entrée correspond-il à celui défini ?

**Si mismatch détecté :**
```
⚠️ Mismatch access-control détecté
Fichier cible    : [fichier]
Éditeur attendu  : [skill ou agent autorisé]
Éditeur réel     : [skill ou agent qui tente l'écriture]
Action           : bloqué — attente de validation humaine
```
Ne pas continuer tant que l'humain n'a pas validé.

---

## Demandes hors roadmap

Toute demande reçue pendant une session est d'abord classifiée :

**Consultation** (expliquer, analyser, répondre à une question) → répondre directement, aucune trace nécessaire.

**Implémentation** (créer, modifier, corriger, ajouter) → vérifier si la tâche existe dans `roadmap.md`.

Si la tâche n'existe pas dans `roadmap.md` :

```
⚠️ Tâche hors roadmap détectée
Demande   : [description de ce qui a été demandé]
Action    : cette tâche n'existe pas dans roadmap.md

Options :
1. Je l'ajoute à roadmap.md et on suit le protocole normal
2. Exception urgente — j'exécute maintenant et je la trace
   immédiatement dans roadmap.md comme [ fait ]
3. On abandonne cette demande
```

Ne rien exécuter tant que l'humain n'a pas choisi une option.

Pour l'option 2, ajouter la ligne dans `roadmap.md` avec statut `[ fait ]`, catégorie, difficulté et agent renseignés, **avant** de commencer l'exécution.

---

## Protocole de session

### PHASE 1 — Démarrage

Exécuter `skills/session-start.md`.

Ce skill :
1. Lit `TODO.md`
2. Lit `roadmap.md`
3. Synchronise : chaque entrée de `TODO.md` est analysée, classifiée et ajoutée dans `roadmap.md` si elle n'existe pas déjà (vérification doublon sur la description)
4. Vide `TODO.md` après sync
5. Identifie les tâches `[ en cours ]` dans `roadmap.md` → les signaler à l'humain comme tâches déjà prises en charge par un autre agent
6. Parmi les tâches `[ à faire ]`, propose la plus prioritaire (P1 en premier, puis tri par difficulté croissante)
7. Présente la proposition à l'humain et attend sa validation

**L'agent ne continue pas tant que l'humain n'a pas validé la tâche.**

---

### PHASE 2 — Classification et routage

Une fois la tâche validée, marquer son statut `[ en cours ]` et son agent dans `roadmap.md`.

Mettre à jour `system/session-state-claude.md` : Phase → 2, catégorie et contraintes actives selon le type de tâche.

Router selon la catégorie de la tâche :

| Catégorie | Protocole |
|---|---|
| `Dev` | Phase 2b (si M+) → Phases 3 → 4 → 5 → unit-tests → 6 → 7 |
| `Design` | Phase 2b (si M+) → Figma. Si tokens ou composants mis à jour : exécuter `figma-sync.md`. Pas de phase 3-5. |
| `Infra` | Phase 2b (si M+) → Phase 3 → implémentation directe → Phase 6 → 7 |
| `Data` | Phase 2b (si M+) → Phase 3 → modification schéma → Phase 6 → 7 |
| `Produit` | Phase 2b (si M+) → Présenter les options à l'humain. Décision humaine → exécuter `update-system.md`. Pas de code. |

---

### PHASE 2b — Product challenge (M+ uniquement)

Exécuter `skills/product-challenge.md`.

Ce skill :
1. Analyse la tâche et identifie hypothèses implicites, edge cases et décisions de design ouvertes
2. Poste toutes les questions en un seul message — attend la réponse humaine
3. Écrit les conclusions dans `system/session-state-claude.md` avant de continuer

**L'agent ne passe pas en Phase 3 tant que l'humain n'a pas répondu au challenge.**

---

### PHASE 3 — Planification (selon difficulté)

Mettre à jour `system/session-state-claude.md` : Phase → 3.

#### Étape 3a — Vérification delta Figma ↔ Specs

Avant de planifier, croiser les informations disponibles :
- La spec de la feature (dossier de specs défini dans `system/governance.md`)
- Le flow correspondant dans `design-system/flows/` (état Figma synchronisé)
- Les composants dans `design-system/components/` (état Figma synchronisé)

**Figma est la source de vérité.** Les specs sont un contexte de départ, pas une référence finale.

Si un écart est détecté entre Figma et les specs (fonctionnalité présente dans les specs mais absente de Figma, comportement différent, composant non représenté, etc.) :

```
⚠️ Delta Figma ↔ Specs détecté
Feature          : [nom de la feature]
Écart            : [description précise de la différence]
Dans les specs   : [ce que disent les specs]
Dans Figma       : [ce que montrent les fichiers design-system/]
Question         : Quelle version fait référence ?
```

Lister tous les écarts détectés avant de poser les questions. **Ne pas trancher seul.** Attendre la décision humaine pour chaque écart avant de continuer.

Si Figma n'a pas encore été designé pour cette feature (fichiers `design-system/flows/` ou `design-system/components/` absents ou vides) : le signaler à l'humain et attendre qu'il confirme si on peut se baser sur les specs en attendant le design Figma.

#### Étape 3b — Évaluation des librairies publiques

Avant de planifier, évaluer s'il existe des librairies publiques pertinentes pour la feature en cours.

Règles :
- Ne proposer une lib que si elle apporte une valeur claire (gain de temps significatif, cas complexe bien couvert, maintenue activement).
- Toujours vérifier : licence gratuite, compatibilité avec la stack du projet, activité récente du repo.
- Ne jamais installer une lib sans validation humaine explicite.
- Si plusieurs options existent, présenter un comparatif court (2-3 lignes par option max) et recommander.
- Si aucune lib ne justifie son ajout, ne rien proposer — l'implémentation native reste la valeur par défaut.

Format de proposition :
```
Lib envisagée : [nom] — [url]
Apport        : [ce qu'elle résout concrètement]
Alternative   : implémentation native (~[estimation effort])
Recommandation : [lib ou natif] — [raison courte]
```

#### Étape 3c — Plan d'implémentation

Une fois les écarts résolus et les libs évaluées :

| Difficulté | Action |
|---|---|
| `XS` ou `S` | Pas de plan. Implémenter directement. |
| `M` | Proposer un plan en 3-5 étapes. Attendre validation humaine avant d'implémenter. |
| `L` ou `XL` | Proposer un plan détaillé avec sous-étapes, fichiers impactés, risques identifiés. Attendre validation humaine. |

Pour construire le plan, consulter :
- `design-system/component-catalog.md`
- `design-system/flows-catalog.md`
- `system/tokens.md`
- `system/memory.md` (décisions passées pertinentes)

---

### PHASE 4 — Audit design (tâches Dev uniquement)

Mettre à jour `system/session-state-claude.md` : Phase → 4.

Avant d'implémenter, exécuter `skills/design-audit.md`.

Ce skill détermine :
- Quels composants existants utiliser ou étendre
- Quels tokens utiliser pour chaque valeur visuelle
- Si un composant ou token manque : bloquer et notifier l'humain

**L'implémentation ne commence pas tant que les deux questions ne sont pas résolues.**

---

### PHASE 5 — Implémentation

Mettre à jour `system/session-state-claude.md` : Phase → 5. Si des décisions sont en attente de validation humaine, les noter dans le champ **Décisions en attente**.

Implémenter selon le plan validé (ou directement si XS/S).

Règles pendant l'implémentation :
- Respecter toutes les conventions de `system/governance.md`
- Ne jamais hardcoder de valeur visuelle
- Ne jamais créer un composant sans avoir exécuté `design-audit.md`
- Si une décision d'implémentation locale est prise (sans impact sur les fichiers système), la noter en commentaire court dans le code
- Si une décision à impact long terme émerge : stopper, proposer à l'humain, attendre validation, puis exécuter `update-system.md`

Une fois l'implémentation terminée, exécuter `skills/unit-tests.md`.

**L'agent ne passe pas en Phase 6 tant que tous les tests unitaires ne sont pas au vert.**

---

### PHASE 6 — Compliance

Mettre à jour `system/session-state-claude.md` : Phase → 6.

Exécuter `skills/compliance.md`.

Ce skill produit un rapport dans le chat couvrant :
- Conformité aux specs
- Conformité aux tokens (`system/tokens.md`)
- Conformité à la gouvernance (`system/governance.md`)
- Absence de composants hardcodés ou dupliqués
- Écarts détectés et leur sévérité

Après le rapport, proposer à l'humain une **liste de tests manuels** à effectuer sur l'implémentation.

**L'agent attend la validation humaine du rapport et des tests avant de continuer.**

---

### PHASE 7 — Clôture

Une fois le compliance validé et les tests manuels effectués par l'humain :

1. Exécuter `skills/commit-protocol.md`
2. Mettre à jour `roadmap.md` : statut → `[ fait ]`, agent → nom de l'agent
3. Mettre à jour `system/memory.md` si des décisions ou trade-offs significatifs ont été faits pendant la session
4. Réinitialiser `system/session-state-claude.md` à l'état par défaut (aucune session active)
5. Signaler à l'humain que la session est terminée et que la tâche est clôturée

---

## Règles transversales

- **Jamais de décision seul** : toute décision produit, architecture ou gouvernance est proposée à l'humain avec une recommandation. L'agent attend la validation.
- **Jamais d'écriture non autorisée** : toujours vérifier `access-control.md` avant d'écrire dans un fichier système.
- **Jamais de valeur hardcodée** : toute valeur visuelle vient de `system/tokens.md`.
- **Jamais de composant créé sans audit** : toujours passer par `design-audit.md`.
- **Jamais de commit sans compliance validé** : le commit ne se fait qu'après validation humaine explicite.
- **Pas d'imbrication** : les skills ne s'appellent pas entre eux. Toute orchestration multi-skill remonte ici.
