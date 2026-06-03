# Memory

Ce fichier est le journal de bord du projet. Il enregistre les décisions, trade-offs et contexte important pris au fil des sessions.

Règles d'écriture :
- Seuls les agents écrivent dans ce fichier, jamais l'humain directement.
- Les entrées sont ajoutées en haut du log (la plus récente en premier).
- Ne jamais modifier ou supprimer une entrée existante.

Ce fichier est alimenté à deux moments précis :

**1. En cours de session** — via le skill `update-system.md`, automatiquement déclenché après chaque décision humaine à impact long terme.

**2. En fin de session** — par l'agent en cours, dans la phase de clôture du protocole AGENTS.md. Si des choix significatifs ont été faits pendant la session sans avoir déclenché `update-system.md`, l'agent les consigne ici avant le commit Git.

Format d'une entrée :

```
## [AAAA-MM-JJ] — Titre court de la décision

**Contexte** : pourquoi cette décision s'est posée
**Décision** : ce qui a été choisi
**Alternatives écartées** : ce qui a été rejeté et pourquoi
**Impact** : fichiers modifiés, règles ajoutées
**Décidé par** : Humain / Agent (avec validation humaine)
```

---

## Log

*(vide — les entrées seront ajoutées au fil des sessions)*
