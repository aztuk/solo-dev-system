# Skill — debugging

## Déclencheur

Sur demande explicite de l'humain quand quelque chose ne fonctionne pas : erreur, comportement inattendu, test qui échoue, régression.

## Modèle recommandé

`low`

---

## Protocole

### Étape 1 — Isoler

Identifier le périmètre exact de la défaillance :
- Quel composant, fichier, fonction ou chemin d'exécution est en cause ?
- Depuis quand ? (dernier commit fonctionnel si possible)
- Reproductible à chaque fois ou intermittent ?

Ne pas chercher la cause avant d'avoir isolé le périmètre.

### Étape 2 — Reproduire

Construire le cas minimal qui déclenche le problème. Si le problème ne peut pas être reproduit de manière fiable, ne pas continuer — signaler à l'humain et demander plus de contexte.

### Étape 3 — Former une hypothèse

Formuler une seule hypothèse falsifiable : "Le problème vient de X parce que Y."

Si plusieurs hypothèses existent, les classer par probabilité et traiter la plus probable d'abord.

Ne pas corriger avant d'avoir une hypothèse.

### Étape 4 — Vérifier

Tester l'hypothèse de façon ciblée : log, assert, test unitaire minimal, lecture du code concerné.

Si l'hypothèse est invalidée : revenir à l'Étape 3 avec la prochaine hypothèse. Ne pas empiler des correctifs sans comprendre.

### Étape 5 — Corriger

Appliquer la correction minimale qui résout le problème reproduit à l'Étape 2.

Ne pas refactorer autour pendant le debug sauf si le refactor est la correction.

Vérifier que le cas de l'Étape 2 ne se reproduit plus.

---

## Règles

- Ne jamais corriger sans avoir reproduit.
- Ne jamais supposer sans hypothèse formulée.
- Une hypothèse à la fois.
- Si après 3 hypothèses le problème reste inexpliqué : escalader à l'humain avec les observations accumulées.
