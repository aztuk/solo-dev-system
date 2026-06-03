# Skill — scaffold-feature

## Déclencheur

Exécuté par AGENTS.md au début de la Phase 5 pour toute tâche de catégorie `Dev`, après que le plan a été validé par l'humain (ou directement si difficulté XS/S).

---

## Protocole

### Étape 1 — Identifier la structure nécessaire

À partir de la spec de la feature et du plan validé, lister :
- Les écrans / pages à créer
- Les composants nécessaires (après `design-audit.md`)
- Les hooks ou services de données à créer
- Les accès API / base de données nécessaires

### Étape 2 — Créer l'arborescence

Adapter la structure ci-dessous à la stack du projet (définie dans `system/governance.md`) :

```
[dossier écrans]/
  (feature-name)/
    index.[ext]       ← écran principal
    [id].[ext]        ← écran détail si applicable

[dossier composants]/
  (feature-name)/
    NomComposant.[ext]

[dossier hooks]/
  useNomFeature.[ext]

[dossier services]/
  (feature-name).[ext]  ← accès API / BDD
```

Créer uniquement les fichiers identifiés à l'étape 1. Ne pas créer de fichiers spéculatifs.

### Étape 3 — Contenu des stubs

Chaque fichier créé contient uniquement :
- Les imports nécessaires
- La signature du composant ou de la fonction
- Un `// TODO: implémenter` comme seul corps
- Aucune logique métier

### Étape 4 — Déclarer les nouveaux composants

Pour chaque composant créé, ajouter une entrée dans `design-system/component-catalog.md` avec statut `draft`.

Ne pas créer le fichier `design-system/components/NomComposant.md` à cette étape — il sera rempli lors de l'implémentation réelle via `design-audit.md`.

### Étape 5 — Confirmer à l'humain

Afficher la liste des fichiers créés et attendre confirmation avant de passer à l'implémentation :

```
Scaffolding terminé pour : [nom de la feature]

Fichiers créés :
- [liste des fichiers]

Entrées ajoutées dans component-catalog.md :
- NomComposant (draft)

Prêt à implémenter. Confirmes-tu ?
```
