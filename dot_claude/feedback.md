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
