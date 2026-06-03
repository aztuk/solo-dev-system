# Skill — create-skill

## Déclencheur

Ce skill s'exécute quand une décision humaine implique la création d'un nouveau skill ou d'un nouvel agent. Ne jamais créer un skill de sa propre initiative.

---

## Règles de conception obligatoires

Avant d'écrire quoi que ce soit, valider ces contraintes :

1. **Pas d'imbrication** : le skill ne doit jamais appeler un autre skill. Si la logique nécessite plusieurs skills, c'est AGENTS.md qui orchestre, pas le skill lui-même.
2. **Responsabilité unique** : un skill fait une seule chose de bout en bout. Si deux responsabilités émergent, ce sont deux skills séparés appelés par AGENTS.md.
3. **Niveau maximum 2** : le skill est toujours au niveau 2 dans la hiérarchie (Humain → AGENTS.md → Skill). Jamais en dessous.
4. **Autonome** : le skill doit pouvoir s'exécuter avec uniquement les fichiers du projet comme contexte. Il ne dépend pas d'un état laissé par un autre skill.

---

## Protocole de création

### 1. Définir le skill

Proposer à l'humain :
- **Nom** du fichier (kebab-case, ex: `design-audit.md`)
- **Déclencheur** : quand AGENTS.md doit-il appeler ce skill ?
- **Entrée** : quel contexte le skill reçoit-il ?
- **Sortie** : quel est le résultat attendu ?
- **Fichiers consultés** : liste des fichiers que le skill lit
- **Fichiers modifiés** : liste des fichiers que le skill peut écrire

Attendre la validation avant de continuer.

### 2. Vérifier l'existant

Lire tous les fichiers dans `/skills/`. Vérifier qu'aucun skill existant ne couvre déjà ce besoin, même partiellement. Si oui, proposer de modifier l'existant plutôt que d'en créer un nouveau.

### 3. Écrire le skill

Créer le fichier dans `/skills/` avec la structure standard :
- `# Skill — nom`
- `## Déclencheur`
- `## Protocole` (étapes numérotées, claires, sans renvoi vers d'autres skills)

### 4. Mettre à jour AGENTS.md

Ajouter le nouveau skill dans la section "Skills disponibles" de AGENTS.md avec son déclencheur.

### 5. Logger dans memory.md

Noter la décision : nom du skill, raison de sa création, date.
