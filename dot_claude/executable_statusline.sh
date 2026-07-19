#!/usr/bin/env bash
# Claude Code status line — thème Tokyo Night.
# Reçoit le JSON de session sur stdin, écrit UNE ligne sur stdout.
# Champs utilisés : model, workspace.current_dir, context_window, rate_limits.
# Compte MAX : pas de coût affiché, mais % de fenêtre 5h + heure de reset.

input=$(cat)

j() { printf '%s' "$input" | jq -r "$1" 2>/dev/null; }

# Palette Tokyo Night (truecolor)
R=$'\033[0m'
blue=$'\033[38;2;122;162;247m'
purple=$'\033[38;2;187;154;247m'
green=$'\033[38;2;158;206;106m'
yellow=$'\033[38;2;224;175;104m'
red=$'\033[38;2;247;118;142m'
cyan=$'\033[38;2;125;207;255m'
gray=$'\033[38;2;86;95;137m'

sep="${gray} │ ${R}"

# Couleur selon un pourcentage (vert < 50 < jaune < 80 < rouge)
pct_color() {
  local p="$1"
  if   [ "$p" -ge 80 ]; then printf '%s' "$red"
  elif [ "$p" -ge 50 ]; then printf '%s' "$yellow"
  else printf '%s' "$green"; fi
}

# --- Dossier ---
dir=$(j '.workspace.current_dir // .cwd // "."')
dirname="${dir##*/}"

# --- Branche git (+ indicateur dirty) ---
branch=""
if git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  b=$(git -C "$dir" branch --show-current 2>/dev/null)
  [ -z "$b" ] && b=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null)
  dirty=""
  [ -n "$(git -C "$dir" status --porcelain 2>/dev/null)" ] && dirty="${yellow}*${R}"
  branch="${sep}${purple} ${b}${R}${dirty}"
fi

# --- Modèle ---
model=$(j '.model.display_name // "?"')
model_str="${sep}${cyan}${model}${R}"

# --- % contexte ---
ctx_str=""
ctx=$(j '.context_window.used_percentage // empty')
if [ -n "$ctx" ]; then
  ci=${ctx%.*}; [ -z "$ci" ] && ci=0
  ctx_str="${sep}${gray}ctx $(pct_color "$ci")${ci}%${R}"
fi

# --- % fenêtre 5h + heure de reset ---
sess_str=""
sess=$(j '.rate_limits.five_hour.used_percentage // empty')
if [ -n "$sess" ]; then
  si=${sess%.*}; [ -z "$si" ] && si=0
  rst=""
  reset=$(j '.rate_limits.five_hour.resets_at // empty')
  [ -n "$reset" ] && rst=" ${gray}⟲$(date -d "@$reset" +%H:%M 2>/dev/null)${R}"
  sess_str="${sep}${gray}5h $(pct_color "$si")${si}%${R}${rst}"
fi

printf '%s%s%s%s%s\n' \
  "${blue} ${dirname}${R}" "$branch" "$model_str" "$ctx_str" "$sess_str"
