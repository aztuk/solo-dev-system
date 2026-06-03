# Skill — figma-sync

## Déclencheur

Exécuté par AGENTS.md dans deux situations :
1. Tâche de catégorie `Design` complétée dans Figma (tokens, composants, ou flows mis à jour).
2. Instruction explicite de l'humain : "synchronise Figma".

Figma est la source de vérité absolue. Ce skill ne modifie jamais Figma — il lit Figma et met à jour les fichiers MD.

---

## Prérequis

Avoir accès au fichier Figma du projet via le MCP Figma (outil `get_design_context`, `get_variable_defs`, `get_screenshot`).

Si le fichier Figma n'est pas accessible, bloquer et notifier l'humain. Ne pas continuer.

---

## Protocole

### Étape 1 — Identifier le périmètre de sync

Demander à l'humain ce qui a été modifié dans Figma :
- Tokens (page Tokens)
- Composants
- Flows / pages
- Tout (sync complète)

Effectuer uniquement la sync du périmètre confirmé.

---

### Étape 2 — Sync tokens (si concerné)

Lire la page **Tokens** du fichier Figma via `get_variable_defs`.

Pour chaque token trouvé dans Figma :
- Identifier la catégorie (color, typography, spacing, radius, shadow)
- Récupérer le nom de la variable Figma, la valeur et la classe NativeWind correspondante
- Mettre à jour la ligne correspondante dans `system/tokens.md`

Règles :
- Si un token Figma n'existe pas encore dans `tokens.md` → l'ajouter dans la bonne section
- Si un token dans `tokens.md` n'existe plus dans Figma → le signaler à l'humain avant de le supprimer
- Ne jamais supprimer un token sans validation humaine explicite

Afficher un résumé : tokens ajoutés, tokens mis à jour, tokens disparus (à valider).

---

### Étape 3 — Sync composants (si concerné)

Lire les composants du fichier Figma via `get_design_context`.

Pour chaque composant trouvé dans Figma :

**3a — Vérifier dans `design-system/component-catalog.md`**
- Composant déjà dans le catalog → mettre à jour son fichier `design-system/components/[nom].md`
- Composant absent du catalog → créer l'entrée dans le catalog et créer le fichier MD

**3b — Contenu du fichier composant**

Remplir ou mettre à jour `design-system/components/[nom].md` avec :
- Nom exact dans Figma
- Node ID Figma
- Variantes disponibles
- States (default, hover, disabled, error, etc.)
- Tokens utilisés (récupérés depuis Figma)
- Règles d'utilisation
- Mapping code (chemin du fichier composant si déjà implémenté)

**3c — Composants supprimés**
Si un composant est dans le catalog mais absent de Figma → signaler à l'humain. Ne pas supprimer sans validation.

Afficher un résumé : composants ajoutés, mis à jour, disparus (à valider).

---

### Étape 4 — Sync flows (si concerné)

Lire les pages/sections du fichier Figma via `get_design_context`.

Pour chaque flow trouvé dans Figma :

**4a — Vérifier dans `design-system/flows-catalog.md`**
- Flow existant → mettre à jour son fichier `design-system/flows/[nom].md`
- Nouveau flow → créer l'entrée dans le catalog et créer le fichier MD

**4b — Contenu du fichier flow**

Remplir ou mettre à jour `design-system/flows/[nom].md` avec :
- Nom du flow
- Pages/écrans inclus dans l'ordre
- Enchaînement entre les écrans (navigation)
- Composants clés utilisés par ce flow
- Node IDs Figma des frames principales
- Edge cases identifiés dans le design

**4c — Flows supprimés**
Si un flow est dans le catalog mais absent de Figma → signaler à l'humain. Ne pas supprimer sans validation.

Afficher un résumé : flows ajoutés, mis à jour, disparus (à valider).

---

### Étape 5 — Résumé global

Afficher à l'humain un récapitulatif de toutes les modifications effectuées et des points nécessitant sa validation (suppressions, ambiguïtés).

Si des suppressions sont en attente de validation → ne pas terminer le skill avant que l'humain ait tranché chaque cas.
