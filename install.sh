#!/usr/bin/env bash

set -euo pipefail

SOURCE="${BASH_SOURCE[0]}"
while [ -L "$SOURCE" ]; do
    DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"
    SOURCE="$(readlink "$SOURCE")"
    [[ "$SOURCE" != /* ]] && SOURCE="$DIR/$SOURCE"
done
DOTFILES_DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"

BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

FILES=(
    bashrc
    vimrc
    tmux.conf
)

DRY_RUN=false
case "${1:-}" in
    -n|--dry-run) DRY_RUN=true ;;
    -h|--help)    grep '^#' "$0" | sed 's/^# \{0,1\}//' | head -12; exit 0 ;;
    "")           ;;
    *)            echo "Unknown option: $1 (try --help)" >&2; exit 1 ;;
esac

run() {
    echo "  + $*"
    $DRY_RUN || "$@"
}

link_one() {
    local name="$1"
    local src="$DOTFILES_DIR/$name"
    local dest="$HOME/.$name"

    if [ ! -e "$src" ]; then
        echo "! skip $name — not found in repo"
        return
    fi

    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "= $dest already linked"
        return
    fi

    echo "~ linking $dest -> $src"

    if [ -L "$dest" ]; then
        run rm "$dest"
    elif [ -e "$dest" ]; then
        run mkdir -p "$BACKUP_DIR"
        run mv "$dest" "$BACKUP_DIR/.$name"
    fi

    run ln -s "$src" "$dest"
}

echo "Dotfiles: $DOTFILES_DIR"
$DRY_RUN && echo "(dry run — no changes will be made)"
echo

for f in "${FILES[@]}"; do
    link_one "$f"
done

echo
if [ -d "$BACKUP_DIR" ]; then
    echo "Replaced files were backed up to: $BACKUP_DIR"
fi
echo "Done."
