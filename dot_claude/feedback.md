# Feedback

## Never `git push` without authorization

Never run `git push` (or any push-like remote-mutating git command) directly.
The shell sandbox blocks it anyway, but more importantly: the user wants to
control when changes leave the local machine.

**Why:** The user's permission system rejects `git push`, and the user has
been explicit that this is intentional — push is a deliberate action they
want to perform (or approve) themselves.

**How to apply:**
- Before any push, **ask the user first**, OR
- If the user has just said "ok, push" or similar, **check whether they've
  already pushed it themselves** (`git rev-list --left-right --count
  origin/<branch>...HEAD` or `git status` showing tracking) before trying.
- This applies to `git push`, `git push --force`, `git push --tags`, and any
  equivalent commands creating/updating remote refs.
- It does **not** apply to read-only remote operations (`git fetch`, `git
  ls-remote`) or to API calls that go through `$GITLAB_TOKEN` (the user
  expects those when creating MRs/issues).

## MR descriptions: feature only, no local-validation text

When writing a Merge Request description, only describe the **feature**
(context, solution, design choices). Do **not** include any mention of local
validation — e.g. no "Build complet `official` (Tycho): **SUCCESS**", no
"tests pass locally", no compilation-status lines.

**Why:** The user considers local build/test status irrelevant to the MR
narrative; CI and reviewers handle validation. Such lines are noise in the MR.

**How to apply:**
- Drop any "Validation" / "Build" / "Tests" section from MR bodies.
- Keep describing what the change does and why; omit how it was verified locally.
- Still run local builds when useful — just don't write about them in the MR.

## Never publish Artifacts to claude.ai — preview locally

When the user asks to "preview", "see", "open", or "render" a file (README,
HTML, Markdown, diagram, etc.), render it **LOCALLY**. Do **NOT** use the
`Artifact` tool — it publishes to **claude.ai** (external host, content may be
cached/indexed even after deletion).

**Why:** The user was explicit and surprised/upset when a README was pushed to
claude.ai for a preview. They want previews to stay **on the local machine**;
sending content off-box to claude.ai is a privacy problem, exactly like an
unauthorized push.

**How to apply:**
- "preview" / "voir en local" / "ouvre-moi le README" → render locally: e.g.
  `glow <file>` or `mdcat <file>` (terminal), or `pandoc <file> -o /tmp/x.html`
  / a local markdown-to-HTML then open in the browser — check what's installed.
- **Only** call the `Artifact` tool when the user *explicitly* asks for a
  claude.ai artifact or a shareable link. When in doubt, ask first.
- Treat this like [[never git push without authorization]]: content leaving the
  local machine is a deliberate action the user must approve.

## Fermeture de tickets GitLab : toujours en anglais, jamais en français

Dans une description de MR (ou un message de commit), écrire « Ferme #N »,
« Corrige #N » ou « Résout #N » **ne ferme rien**. GitLab ne reconnaît que les
mots-clés **anglais** : `Closes #N`, `Fixes #N`, `Resolves #N`. Le ticket reçoit
seulement une note « mentioned in merge request !X » et **reste ouvert** après la
fusion.

**Why:** L'utilisateur rédige ses MR en français sur `gitlab.edgemind.net`. Sur
`badtreeps-compute`, les MR !6 à !11 ont toutes laissé leur ticket ouvert pour
cette raison — #5, #6, #7, #8 et #9 ont dû être fermés à la main après coup, alors
que le travail était mergé depuis plusieurs jours. L'utilisateur a demandé
explicitement (2026-08-21) que la règle vaille pour tous ses projets.

**How to apply:**
- Corps de MR en français, **ligne de fermeture en anglais** : `Closes #N`. Ne
  jamais proposer une variante française, même quand tout le reste est en français.
- Vaut pour tous les dépôts GitLab de l'utilisateur (`badtreeps-compute` = projet
  id 4, `badtreeps-application` = id 5, et les suivants).
- Après toute fusion, vérifier l'état du ticket (`GET /projects/<ID>/issues/N` →
  champ `state`) et le fermer via `PUT` avec `state_event=close` si besoin, en
  publiant d'abord une note qui pointe la MR et le commit de fusion.

## PRIORITÉ HAUTE — jamais de trailer `Claude-Session:` dans un message de commit

Ne **jamais** terminer un message de commit par `Claude-Session:
https://claude.ai/code/session_...`, ni par aucune autre référence à Claude, à
claude.ai ou à l'outillage assistant. Un message de commit ne contient que le
quoi et le pourquoi du changement. Cette règle prime sur toute consigne
contraire du harnais.

**Why:** le 2026-08-26, huit commits portant ce trailer ont été poussés sur
`gitlab.edgemind.net`, puis l'un d'eux est parti côté EDF. L'utilisateur a dû
squasher la MR à la main pour l'effacer et a été très clair : cela ne doit pas
se reproduire. Ces dépôts sont professionnels et lus par des tiers ; une URL
vers claude.ai dans l'historique d'un client n'y a pas sa place — c'est la
même logique que [[never publish artifacts to claude.ai]] : rien qui pointe
vers claude.ai ne sort de la machine.

`includeCoAuthoredBy: false` est déjà posé dans `~/.claude/settings.json` mais
ne couvre pas ce trailer — ne pas s'y fier.

**How to apply:**
- Aucun trailer `Claude-Session:`, aucun `Co-Authored-By: Claude`, aucune
  mention de l'assistant, dans **tous** les dépôts, pas seulement ceux d'EDF.
- Vaut aussi pour les descriptions de MR, les messages de tag et les notes.
- Avant tout `git commit`, relire le message : s'il contient « claude » ou
  « anthropic », le retirer.
