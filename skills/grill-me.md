# Skill — grill-me

## Déclencheur

Avant `skills/phase-analyse.md` pour toute tâche en phase Analyse.

Également sur demande explicite de l'humain : "grill me", "grill-me", "interview me", "pressure-test", "aide-moi à clarifier", ou demande vague qui ressemble plus à une décision qu'à une tâche directement exécutable.

## Modèle recommandé

`low` par défaut. Monter à `mid` si la décision touche produit, architecture, gouvernance ou plusieurs domaines.

---

## Protocole

### Étape 1 — Installer le cadre

Rappeler brièvement que l'objectif est de clarifier l'intention, les contraintes, les hypothèses cachées et les alternatives avant d'agir.

Ne pas lire d'artefact de tâche avant la première question, sauf si l'humain a explicitement pointé vers un fichier de brief.

### Étape 2 — Boucle d'interview

Interviewer l'humain une question à la fois.

Pour chaque question :
- fournir une recommandation ou un strawman concret que l'humain peut corriger ;
- attendre la réponse avant de passer à la suite ;
- approfondir la réponse reçue avant de changer de branche ;
- si la réponse est vague, proposer une hypothèse falsifiable plutôt que d'accepter le flou ;
- relever poliment les contradictions, arbitrages implicites et zones de non-décision.

**Claude Code** : utiliser l'outil `AskUserQuestion` pour chaque question. Formuler 2 à 4 options concrètes que l'humain peut sélectionner ou corriger via "Other". Chaque option doit avoir un `label` court et une `description` qui explicite le trade-off ou l'implication. Utiliser `multiSelect: true` si les choix ne sont pas mutuellement exclusifs.

**Codex** : poser les questions en texte, une à la fois, avec une recommandation ou un strawman inline.

Si une question peut être résolue en explorant la codebase, explorer plutôt que demander. Logger chaque lecture significative dans le `Context usage log` du session-state.

### Étape 3 — Lenses à mobiliser

Adapter les questions au domaine sans nommer les lenses à l'humain.

Piocher selon le besoin :
- problème réel vs solution imaginée ;
- résultat attendu et définition de "réussi" ;
- personnes impactées et contexte d'usage ;
- contraintes non négociables ;
- hypothèses cachées ;
- seconde meilleure alternative ;
- pré-mortem ;
- steelman de l'option opposée ;
- réversibilité ;
- limites de scope ;
- coût de maintenance et soutenabilité.

### Étape 4 — Critère d'arrêt

Ne pas conclure dès que la demande semble comprise. Quand l'agent pense pouvoir agir, poser encore les questions nécessaires pour vérifier les hypothèses les plus risquées.

Arrêter uniquement quand la prochaine action concrète devient possible : rédiger l'exploration, planifier, modifier un fichier, écrire un brief ou abandonner la demande.

### Étape 5 — Handoff

Produire un handoff court dans la conversation, structuré ainsi :

```markdown
## Grill handoff

**Intent** : [ce que l'humain veut vraiment obtenir]
**Contraintes** : [non négociables]
**Décisions clés** : [choix actés + raison]
**Hypothèses surfacées** : [hypothèses maintenant explicites]
**Alternatives écartées** : [options rejetées + raison]
**Hors scope** : [limites acceptées]
**Questions ouvertes** : [reste à trancher, ou "aucune"]
**Prochaine action recommandée** : [phase ou action suivante]
```

Ce handoff est le matériau d'entrée de `skills/phase-analyse.md` quand la tâche suit le pipeline standard.
