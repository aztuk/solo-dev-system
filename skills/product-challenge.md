# Skill — product-challenge

## Declencheur

Apres classification de la tache (Phase 2), pour toute tache M, L ou XL.
Categories concernees : Dev, Design, Produit.
Ignore pour XS et S — passer directement a la Phase 3.

---

## Protocole

### Etape 1 — Analyse

Lire :
- La description de la tache validee dans `roadmap.md`
- La spec correspondante si elle existe
- `system/memory.md` (decisions passees pertinentes)
- Pour les taches Dev : `design-system/flows/` et `design-system/components/` si pertinents

Identifier :
- Ce que la spec suppose implicitement sans l'avoir explicite
- Les situations limites non couvertes par la description
- Les choix UX ou produit qui ont un impact sur l'implementation et qui n'ont pas ete tranches

### Etape 2 — Poster le challenge en un seul message

Format obligatoire :

```
## Product challenge — [nom de la tache]

**Hypotheses a valider**
- [hypothese implicite detectee]
- ...

**Edge cases identifies**
- [situation limite non couverte]
- ...

**Decisions de design ouvertes**
- [choix UX ou produit a trancher]
- ...

Reponds a ces points avant que je commence la planification.
```

Regles :
- Un seul message. Ne pas poser de question de suivi.
- Ne pas proposer de solutions dans ce message — uniquement poser les questions.
- Si aucune question pertinente n'est identifiee, l'indiquer brievement et passer directement a la Phase 3.

### Etape 3 — Attendre la reponse

Ne rien faire tant que l'humain n'a pas repondu.

### Etape 4 — Ecrire la synthese dans session-state-claude.md

Une fois la reponse recue, mettre a jour `system/session-state-claude.md` :
- Phase → 2b (challenge complete)
- Ajouter le champ **Challenge conclusions** avec un resume des decisions prises (2-5 lignes max, format bullet)

Ces conclusions servent de contexte pour toute la suite de la session.

Puis continuer vers Phase 3 — Planification.
