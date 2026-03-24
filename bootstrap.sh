#!/bin/bash
# Bootstrap script — install chezmoi and apply dotfiles on a fresh machine
# Usage: curl -fsSL https://raw.githubusercontent.com/gurvanlm/chezmoi/main/bootstrap.sh | bash
set -euo pipefail

echo "=== Dotfiles Bootstrap ==="

# Install chezmoi if not present
if ! command -v chezmoi &> /dev/null; then
    echo "Installing chezmoi..."
    sh -c "$(curl -fsSL https://chezmoi.io/get)" -- -b ~/.local/bin
    export PATH="$HOME/.local/bin:$PATH"
fi

# Init and apply dotfiles
echo "Applying dotfiles..."
chezmoi init --apply gurvanlm/chezmoi

echo ""
echo "=== Done! ==="
echo "Restart your shell or run: source ~/.zshrc"
echo "Then run: tools-update --check"
