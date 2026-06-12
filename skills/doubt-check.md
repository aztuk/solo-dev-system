# Skill — doubt-check

## Déclencheur

Dans `skills/phase-implementation.md` (Étape 4), quand une décision produit ou architecture imprévue apparaît pendant l'implémentation.

Exécuter avant de remonter la décision à l'humain — pour distinguer ce qui mérite vraiment une escalade de ce qui peut être résolu localement.

## Modèle recommandé

`low`

---

## Protocole

### Étape 1 — Nommer la décision

Formuler la décision imprévue en une phrase : "Je dois choisir entre X et Y."

Si la décision ne peut pas être formulée ainsi, c'est qu'elle est encore floue — clarifier d'abord.

### Étape 2 — Challenge adversarial

Pour l'option envisagée, répondre à ces questions :

- **Qu'est-ce qui doit être vrai pour que ce choix soit mauvais ?**
- **Quel est le pire scénario réaliste dans 3 mois ?**
- **Est-ce que le plan validé (plan.md) donne une direction implicite ?**
- **Est-ce réversible ?** Si oui, un choix raisonnable suffit.

### Étape 3 — Critère de résolution locale

Résoudre localement (sans escalade) si les trois conditions sont remplies :
1. La décision est réversible sans refactor majeur.
2. Elle reste dans le périmètre technique de la tâche.
3. Elle ne touche pas au produit, à l'architecture globale, ni à la gouvernance.

### Étape 4 — Sortie

**Si résolution locale possible** :
```
Doubt-check : résolu localement
Décision : [choix retenu]
Raison : [pourquoi c'est raisonnable et réversible]
```
Continuer l'implémentation.

**Si escalade nécessaire** :
```
Doubt-check : escalade requise
Décision bloquante : [formulation en une phrase]
Options identifiées : [A / B]
Recommandation : [option + raison]
Question pour l'humain : [ce qui doit être tranché]
```
Stopper et soumettre à l'humain.
