# Skill — update-system

## Déclencheur

Ce skill s'exécute après chaque décision humaine à impact long terme : décision produit, décision d'architecture, changement de règle de gouvernance, ajout/modification d'une convention.

Ne jamais exécuter ce skill de sa propre initiative. Toujours attendre que l'humain ait pris et confirmé une décision.

## Protocole

### 1. Identifier la portée de la décision

Déterminer quels fichiers sont impactés parmi :
- `system/governance.md` — si la décision change une règle ou convention
- `later.md` — si la décision concerne une limite MVP ou une dette technique
- `AGENTS.md` — si le protocole d'orchestration est modifié
- `CLAUDE.md` — si le comportement de Claude Code spécifiquement change
- `/skills/*.md` — si un ou plusieurs skills doivent être mis à jour
- `system/tokens.md` — si les design tokens sont affectés
- `design-system/component-catalog.md` — si les composants sont affectés

### 2. Proposer les modifications

Avant d'écrire quoi que ce soit, présenter à l'humain :
- La liste des fichiers à modifier
- Le contenu exact des changements proposés

Attendre la validation explicite avant d'écrire.

### 3. Vérifier la règle d'architecture

Avant d'appliquer, vérifier que les modifications respectent la règle d'imbrication définie dans `system/governance.md` :
- Aucun skill ne doit appeler un autre skill.
- Toute orchestration multi-skill remonte dans AGENTS.md.
- Si la décision implique la création d'un nouveau skill ou agent, utiliser le skill `create-skill.md`.

### 4. Appliquer les modifications

Mettre à jour chaque fichier identifié. Une modification par fichier, dans l'ordre de la liste.

### 5. Logger dans memory.md

Ajouter une entrée dans `system/memory.md` :
- Date
- Décision prise
- Fichiers mis à jour
- Raisonnement ou contexte donné par l'humain

Exception : si l'humain dispense explicitement la session de mise à jour `memory.md`, ne rien écrire dans `memory.md` et mentionner cette dispense dans le rapport final.
