#!/usr/bin/env bash
set -euo pipefail

# folio-cli install script
#   curl -fsSL https://raw.githubusercontent.com/jubalm/folio-cli/main/install.sh | bash

REPO="jubalm/folio-cli"
BRANCH="main"
BIN_URL="https://raw.githubusercontent.com/$REPO/$BRANCH/bin/folio"
FOLIO_HOME="$HOME/.config/folio"
TARGET="$FOLIO_HOME/bin/folio"

# Detect shell rc
detect_rc() {
  case "${SHELL:-}" in
    */zsh) echo "$HOME/.zshrc" ;;
    */bash) echo "$HOME/.bashrc" ;;
    *) return 1 ;;
  esac
}

echo "folio: installing to $TARGET"

mkdir -p "$FOLIO_HOME/bin"

# Download
if command -v curl &> /dev/null; then
  curl -fsSL "$BIN_URL" -o "$TARGET" || { echo "folio: download failed"; exit 1; }
elif command -v wget &> /dev/null; then
  wget -q "$BIN_URL" -O "$TARGET" || { echo "folio: download failed"; exit 1; }
else
  echo "folio: need curl or wget"
  exit 1
fi

chmod +x "$TARGET"

# Ensure on PATH
if command -v folio &> /dev/null; then
  echo "folio: already on PATH ($(which folio))"
else
  rc="$(detect_rc || true)"
  if [[ -n "$rc" ]] && ! grep -q '\.config/folio/bin' "$rc" 2>/dev/null; then
    echo "" >> "$rc"
    echo 'export PATH="$HOME/.config/folio/bin:$PATH"' >> "$rc"
    echo "folio: added \$HOME/.config/folio/bin to PATH in $rc"
    echo "       source $rc or open a new terminal"
  else
    echo "folio: installed at $TARGET"
    echo "       add to PATH: export PATH=\"\$HOME/.config/folio/bin:\$PATH\""
  fi
fi

echo ""
folio --version 2>/dev/null || echo "folio — knowledge management over git"
echo ""
echo "  folio init              # initialize a store for this project"
echo "  folio sync              # pull main + publish local edits via PR"
echo "  folio sync -m \"msg\"     # non-interactive (agents)"
echo "  folio list              # list all stores"
echo "  folio status            # current project/store status"
echo "  folio config            # show global config"
echo ""
