# Skill — session-start

## Déclencheur

Début de chaque session, quel que soit l'agent. C'est toujours le premier skill exécuté.

---

## Protocole

### Étape 1 — Lecture

Lire dans cet ordre :
1. `TODO.md`
2. `roadmap.md`
3. `system/memory.md` (les 5 dernières entrées suffisent pour le contexte)

---

### Étape 2 — Synchronisation TODO → roadmap.md

Pour chaque entrée présente dans `TODO.md` :

#### 2a — Vérifier les doublons
Comparer la description de l'entrée avec les tâches existantes dans `roadmap.md` (statuts `[ à faire ]`, `[ en cours ]` et `[ fait ]`).
- Si une tâche identique ou très proche existe déjà → ignorer l'entrée, ne pas créer de doublon.
- Si la tâche existe avec statut `[ fait ]` → signaler à l'humain : "Cette tâche semble déjà effectuée — confirmes-tu qu'il faut la relancer ?"

#### 2b — Classifier la tâche
Pour chaque entrée nouvelle (non doublon), déterminer :

| Champ | Valeur possible | Critère de classification |
|---|---|---|
| Catégorie | `Dev` | Implémentation code, composants, features |
| | `Design` | Figma, tokens, composants visuels, flows |
| | `Infra` | Setup, configuration, dépendances, CI |
| | `Data` | Schéma BDD, migrations |
| | `Produit` | Décision de scope, règle métier, priorité |
| Priorité | `P1` | Bloquant pour la phase en cours |
| | `P2` | Important mais non bloquant |
| | `P3` | Nice to have |
| Difficulté | `XS` | < 30 min, modification isolée |
| | `S` | 30 min – 1h, un seul fichier ou composant |
| | `M` | 1h – 3h, plusieurs fichiers, un flow complet |
| | `L` | 3h – 1 jour, feature complète |
| | `XL` | > 1 jour, feature complexe ou refactoring majeur |

Si la classification n'est pas évidente depuis le texte de l'entrée, choisir la valeur la plus prudente (priorité basse, difficulté haute) et le signaler à l'humain.

#### 2c — Identifier les références
Si l'entrée mentionne une spec, un lien Figma ou une URL externe, les ajouter dans la colonne Références.

#### 2d — Ajouter dans roadmap.md
Ajouter la ligne dans le tableau de `roadmap.md` avec statut `[ à faire ]` et agent `—`.

---

### Étape 3 — Vider TODO.md

Une fois la sync terminée, vider la section d'entrées de `TODO.md`. Ne conserver que l'en-tête et les instructions du fichier.

---

### Étape 4 — Présenter un résumé de sync

Afficher à l'humain :
- Nombre de tâches ajoutées à `roadmap.md`
- Nombre de doublons ignorés
- Tâches actuellement `[ en cours ]` (pour information seulement — un autre agent travaille dessus)
- Tâches nécessitant une clarification (si applicable)

---

### Étape 5 — Proposer la prochaine tâche

Sélectionner la tâche `[ à faire ]` la plus prioritaire selon cet ordre :
1. Priorité P1 en premier
2. À priorité égale, difficulté la plus faible en premier (commencer par ce qui débloquerait d'autres tâches)

Ignorer toutes les tâches `[ en cours ]` sans poser de question — elles sont prises en charge par un autre agent en parallèle. Ne pas les mentionner autrement que dans le résumé de sync.

Présenter la proposition à l'humain :

```
Tâche proposée : [description]
Catégorie      : [catégorie]
Priorité       : [P1/P2/P3]
Difficulté     : [XS/S/M/L/XL]
Références     : [liens ou fichiers]

Confirmes-tu qu'on travaille sur cette tâche ?
Si non, indique quelle tâche tu préfères traiter.
```

**Attendre la validation explicite de l'humain avant de continuer vers la Phase 2 de AGENTS.md.**
