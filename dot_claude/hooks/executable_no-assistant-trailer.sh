#!/usr/bin/env bash
# Refuse tout git commit / tag / merge dont le message porte une marque
# d'attribution à l'assistant (Claude-Session, Co-Authored-By: Claude,
# claude.ai, anthropic.com).
#
# POURQUOI : le 2026-08-26, huit commits portant un trailer « Claude-Session:
# https://claude.ai/... » sont partis sur un dépôt professionnel, dont un côté
# client. La règle est écrite dans ~/.claude/feedback.md, mais une consigne se
# contourne par distraction — ce hook, non.
#
# POURQUOI PAS LE SEUL RÉGLAGE attribution : attribution.sessionUrl=false et
# attribution.commit="" coupent la source côté Claude Code, et c'est le vrai
# correctif. Ce hook est la ceinture qui va avec les bretelles : il attrape
# aussi un message rédigé à la main, ou un futur trailer qu'aucun réglage ne
# couvrirait.
#
# Le hook reçoit le JSON de l'appel d'outil sur stdin et répond sur stdout :
# silence = laisser passer, JSON permissionDecision=deny = refuser.
set -uo pipefail

cmd=$(jq -r '.tool_input.command // ""' 2>/dev/null) || exit 0
[ -n "$cmd" ] || exit 0

# On ne regarde que les commandes qui écrivent un message dans git. Sans ce
# filtre, un simple `curl https://claude.ai` serait refusé.
case "$cmd" in
  *"git commit"*|*"git tag"*|*"git merge"*|*"git notes"*) ;;
  *) exit 0 ;;
esac

# Marques d'attribution, jamais du contenu légitime dans un message de commit.
# Volontairement plus étroit que « claude » tout court : « ajout du hook
# claude-code » doit rester possible.
motif='Claude-Session|Co-Authored-By:[[:space:]]*Claude|claude\.ai|anthropic\.com|Generated with .*Claude'

if printf '%s' "$cmd" | grep -qiE "$motif"; then
  cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Message git contenant une marque d'attribution à l'assistant (Claude-Session, Co-Authored-By, claude.ai...). Interdit sur tous les dépôts — voir la règle dans ~/.claude/feedback.md. Réécrire le message sans cette ligne."}}
JSON
fi

exit 0
