# Skill — product-challenge

## Declencheur

Apres classification de la tache (Phase 2), pour toute tache M, L ou XL.
Categories concernees : Dev, Design, Produit.
Ignore pour XS et S — passer directement a la Phase 3.

---

## Protocole

### Etape 1 — Analyse

Lire :
- La description de la tache validee dans le fichier de session
- `roadmap.md` seulement si la tache y est deja suivie
- La spec correspondante si elle existe
- `system/memory.md` (decisions passees pertinentes)
- Pour les taches Dev : `design-system/flows/` et `design-system/components/` si pertinents

Identifier :
- Ce que la spec suppose implicitement sans l'avoir explicite
- Les situations limites non couvertes par la description
- Les choix UX ou produit qui ont un impact sur l'implementation et qui n'ont pas ete tranches

### Etape 2 — Cadrer le challenge (message court)

Avant de poser les questions, afficher un message bref (3-5 lignes max) qui resume :
- Le titre du challenge : `## Product challenge — [nom de la tache]`
- En une phrase, ce qui est globalement clair et ne sera pas questionne
- Le nombre de points a trancher (ex : « 4 points a trancher, je te les pose un par un »)

Ne pas lister toutes les questions a plat dans ce message. Ce message sert uniquement a poser le contexte.

### Etape 3 — Poser les questions une a une via AskUserQuestion

Transformer chaque point identifie a l'Etape 1 (hypothese a valider, edge case, decision ouverte) en **une question fermee avec des propositions concretes**, puis les poser **une par une** avec l'outil `AskUserQuestion`.

Regles imperatives :
- **Un seul appel `AskUserQuestion` par question** (une seule question dans le tableau `questions`). Ne pas batcher plusieurs questions dans un meme appel. L'objectif est que l'humain lise et reponde a une chose a la fois, et que chaque reponse puisse informer la question suivante.
- Poser les questions dans l'ordre de dependance : les choix structurants (qui conditionnent les suivants) d'abord.
- Chaque question doit **proposer des options** (2 a 4), pas juste poser une question ouverte. C'est le coeur du changement : l'humain choisit parmi des propositions plutot que de rediger des reponses.
  - Quand une option est recommandee, la placer en premier et suffixer son `label` par ` (Recommande)`.
  - Le `description` de chaque option doit expliciter l'implication ou le trade-off du choix (1 phrase).
  - Le `header` est un label court (max 12 caracteres) : ex. `Typo`, `Tokens`, `Palette`, `Scope`.
- Pour une **hypothese a valider**, formuler la question en « Confirmer / Ajuster » : option 1 = l'hypothese telle que detectee, option(s) suivante(s) = alternative(s) plausible(s).
- Pour un **edge case**, proposer les traitements possibles comme options.
- Utiliser le champ `preview` uniquement quand une comparaison visuelle aide (ex. snippets de code, palettes hex, layouts). Sinon s'en passer.
- Ne pas inventer d'option « Autre » : l'outil l'ajoute automatiquement, et l'humain peut toujours saisir une reponse libre.
- Si un point ne se prete vraiment pas a des propositions fermees (reponse purement ouverte, ex. « fournis les valeurs hex »), le poser quand meme via `AskUserQuestion` avec des options de cadrage (ex. « Je propose une palette que tu ajustes » / « Tu fournis les hex directement »).
- Si aucune question pertinente n'est identifiee, l'indiquer brievement et passer directement a la Phase 3 sans appeler `AskUserQuestion`.

Attendre la reponse de chaque question avant de poser la suivante. Ne rien implementer tant que toutes les questions ne sont pas tranchees.

### Etape 4 — Ecrire la synthese dans le fichier de session

Une fois la reponse recue, mettre a jour le fichier de session de cette session (`system/.session-state/<id>.md`) :
- Phase → 2b (challenge complete)
- Ajouter le champ **Challenge conclusions** avec un resume des decisions prises (2-5 lignes max, format bullet)

Ces conclusions servent de contexte pour toute la suite de la session.

Puis continuer vers la Phase Analyse.
