# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

This is a [chezmoi](https://www.chezmoi.io/) dotfiles repository. Chezmoi manages dotfiles across machines by storing them in this source directory (`~/.local/share/chezmoi/`) and applying them to the home directory.

## Key Commands

- `chezmoi apply` — apply changes from this repo to the home directory
- `chezmoi diff` — preview what `apply` would change
- `chezmoi add ~/.<file>` — add a dotfile to this repo
- `chezmoi edit ~/.<file>` — edit a managed file in this repo
- `chezmoi cd` — open a shell in this source directory
- `chezmoi data` — view template data (useful when editing `.tmpl` files)

## Chezmoi File Naming Conventions

Files in this repo use chezmoi's naming scheme — they are **not** named the same as their targets:

- `dot_` prefix → `.` (e.g., `dot_bashrc` → `~/.bashrc`)
- `private_` prefix → file gets `0600` permissions
- `executable_` prefix → file gets executable bit
- `run_` prefix → script that runs on `chezmoi apply` (not installed as a file)
- `run_once_` / `run_onchange_` → run scripts with execution tracking
- `.tmpl` suffix → Go template, rendered using `chezmoi data`
- `modify_` prefix → script that modifies an existing file rather than replacing it

Directories use the same `dot_` and `private_` conventions.

## Installation Scripts Pattern

Les scripts d'installation sont sélectifs : l'utilisateur choisit quoi installer via `chezmoi init`.

- `.chezmoi.toml.tmpl` contient les prompts (`promptBoolOnce`) → stockés dans `~/.config/chezmoi/chezmoi.toml` sous `[data]`
- Les scripts sont dans `.chezmoiscripts/` (dossier spécial chezmoi, pas créé dans `~`)
- Chaque script est un `run_onchange_XX-install-<nom>.sh.tmpl` conditionné par `{{- if .<variable> }}...{{- end }}`
- Quand la variable est `false`, le template rend un contenu vide → chezmoi ne l'exécute pas
- Cibles : Debian/Ubuntu (serveur et desktop)
- Les outils desktop (wezterm, vscode, eclipse, obsidian, dbeaver, chatbox, gittyup) sont conditionnés à la présence d'une session graphique (XDG_SESSION_TYPE ou DISPLAY)

**Pour ajouter un nouveau script d'installation :**
1. Ajouter un `promptBoolOnce` dans `.chezmoi.toml.tmpl`
2. Créer `.chezmoiscripts/run_onchange_XX-install-<nom>.sh.tmpl` avec le garde `{{- if .<variable> }}`
3. Utiliser le numéro XX suivant pour l'ordre d'exécution
4. **Ajouter l'outil dans `dot_local/bin/executable_tools-update`** (tableau `TOOLS`) pour le suivi des mises à jour

**Scripts perso :** placés dans `dot_local/bin/executable_<nom>` → installés dans `~/.local/bin/`

## Installed Tools

### Shell & Prompt
| Script | Outil | Méthode | Sudo |
|--------|-------|---------|------|
| 00 | **zsh** | apt | oui |
| 02 | **starship** (prompt Tokyo Night) | binaire GitHub → `~/.local/bin/` | non |
| 03 | **sheldon** (plugin manager zsh) | binaire GitHub → `~/.local/bin/` | non |

**Plugins zsh** (gérés par sheldon via `dot_config/sheldon/plugins.toml`) :
- zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions, zsh-history-substring-search, fzf-tab

### CLI Tools (script 04)
Binaires GitHub dans `~/.local/bin/` (sans sudo) + quelques paquets apt :
- **jq** — processeur JSON (apt)
- **tealdeer** — pages man simplifiées, commande `tldr` (apt)
- **direnv** — variables d'env par dossier projet (apt)
- **fzf** — fuzzy finder (Ctrl+R, Ctrl+T, Alt+C)
- **eza** — remplacement ls avec icônes
- **bat** — remplacement cat avec syntax highlighting (thème Tokyo Night)
- **fd** — remplacement find
- **ripgrep** (rg) — remplacement grep
- **zoxide** — remplacement cd intelligent
- **yazi** — file manager terminal (thème Tokyo Night)
- **lazygit** — interface git interactive (thème Tokyo Night)
- **lazydocker** — interface docker interactive
- **btop** — moniteur système (thème Tokyo Night)
- **dust** — remplacement du (espace disque en arbre)
- **duf** — remplacement df (partitions en tableau)
- **glow** — rendu Markdown dans le terminal
- **httpie** — requêtes HTTP lisibles, commande `http` (apt)

### SDK & Langages
| Script | Outil | Méthode | Sudo |
|--------|-------|---------|------|
| 05 | **SDKMAN** (Java LTS + Maven) | script officiel → `~/.sdkman/` | non (sauf zip/unzip) |
| 11 | **nvm** (Node.js LTS + npm-check-updates) | script officiel → `~/.nvm/` | non |
| 12 | **uv** (Python package manager) | script officiel → `~/.local/bin/` | non |

### Desktop — Terminal & Éditeurs
| Script | Outil | Méthode | Sudo |
|--------|-------|---------|------|
| 01 | **WezTerm** (terminal, Tokyo Night) | dépôt APT fury.io | oui |
| 06 | **Eclipse RCP** | tarball eclipse.org → `~/.local/share/eclipse/` | non |
| 08 | **VS Code** | dépôt APT Microsoft | oui |
| 09 | **Extensions VS Code** | `code --install-extension` | non |

**Extensions VS Code** : Tokyo Night, Volar (Vue), Java, Java Debug, Maven, Rainbow CSV, Markdown Mermaid

### Desktop — Outils
| Script | Outil | Méthode | Sudo |
|--------|-------|---------|------|
| 07 | **Docker** + Compose + BuildX | dépôt APT Docker officiel | oui |
| 10 | **Obsidian** + clone vault `~/brain` | .deb GitHub releases | oui |
| 13 | **DBeaver CE** | dépôt APT officiel dbeaver.io | oui |
| 14 | **ChatBox** (AI client) | .deb depuis chatboxai.app | oui |
| 15 | **Gittyup** (git GUI) | AppImage GitHub → `~/.local/bin/` | non |
| 16 | **tmux** + TPM + plugins | apt + git clone | oui |

### Post-install
| Script | Action |
|--------|--------|
| 99 | Rebuild cache bat (thèmes) |

## Managed Config Files

| Fichier chezmoi | Cible | Description |
|----------------|-------|-------------|
| `dot_zshrc` | `~/.zshrc` | Config zsh (plugins, aliases, init outils) |
| `dot_gitconfig` | `~/.gitconfig` | Git config (identité, aliases, pager bat) |
| `dot_zprofile` | `~/.zprofile` | Variables d'env login shell (EDITOR, LANG) |
| `dot_config/starship.toml` | `~/.config/starship.toml` | Prompt Tokyo Night (hostname SSH, Java) |
| `dot_config/sheldon/plugins.toml` | `~/.config/sheldon/plugins.toml` | Plugins zsh |
| `dot_config/wezterm/wezterm.lua` | `~/.config/wezterm/wezterm.lua` | Terminal (Tokyo Night, police, Shift+Enter) |
| `dot_config/tmux/tmux.conf` | `~/.config/tmux/tmux.conf` | Tmux (Tokyo Night, Ctrl+Space prefix, plugins) |
| `dot_config/lazygit/config.yml` | `~/.config/lazygit/config.yml` | Lazygit thème Tokyo Night |
| `dot_config/git/ignore` | `~/.config/git/ignore` | Gitignore global (.env, node_modules, .idea...) |
| `dot_config/bat/themes/` | `~/.config/bat/themes/` | Thème bat Tokyo Night |
| `dot_config/yazi/theme.toml` | `~/.config/yazi/theme.toml` | Thème yazi Tokyo Night |
| `dot_config/Code/User/settings.json` | `~/.config/Code/User/settings.json` | VS Code settings (Tokyo Night) |
| `dot_claude/settings.json` | `~/.claude/settings.json` | Claude Code permissions |
| `dot_m2/settings.xml.tmpl` | `~/.m2/settings.xml` | Maven settings (Nexus credentials via template) |
| `private_dot_ssh/private_config.tmpl` | `~/.ssh/config` | SSH config (GitHub, GitLab, serveurs) |
| `dot_local/bin/executable_tools-update` | `~/.local/bin/tools-update` | Script de vérification/mise à jour des outils |

## Secrets Management

Les secrets ne sont pas versionnés dans git :
- `~/.config/chezmoi/chezmoi.toml` (local) → injectés via templates `.tmpl` : `nexusUser` / `nexusPassword`
- `~/.config/env-secrets` → tokens exportés dans le shell (ex: `GITHUB_TOKEN`), sourcé par `.zshrc`
- Pour de futurs secrets, envisager l'intégration Bitwarden de chezmoi.

## Theme

Le thème visuel choisi est **Tokyo Night**. Tous les outils doivent suivre cette palette quand c'est possible (starship, wezterm, éditeurs, etc.).

Couleurs principales Tokyo Night :
- Bleu : `#7aa2f7`
- Violet : `#bb9af7`
- Vert : `#9ece6a`
- Jaune : `#e0af68`
- Rouge : `#f7768e`
- Cyan : `#7dcfff`
- Gris (commentaires) : `#565f89`
- Fond : `#1a1b26`
- Texte : `#c0caf5`

## Editing Guidelines

- When editing `.tmpl` files, use Go's `text/template` syntax. Access machine-specific data via `{{ .chezmoi.os }}`, `{{ .chezmoi.hostname }}`, etc.
- Never put secrets directly in files — use `chezmoi secret` or template variables from a config file.
- After making changes, use `chezmoi diff` to verify before `chezmoi apply`.
