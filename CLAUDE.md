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

**Pour ajouter un nouveau script d'installation :**
1. Ajouter un `promptBoolOnce` dans `.chezmoi.toml.tmpl`
2. Créer `.chezmoiscripts/run_onchange_XX-install-<nom>.sh.tmpl` avec le garde `{{- if .<variable> }}`
3. Utiliser le numéro XX suivant pour l'ordre d'exécution

**Scripts perso :** placés dans `dot_local/bin/executable_<nom>` → installés dans `~/.local/bin/`

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
