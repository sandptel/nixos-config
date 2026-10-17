# dotfiles: keep $DOTS (a checkout of $DOTS_REMOTE) symlinked into $HOME.
#   link         symlink every path in $DOTS/tracked into $HOME
#   track PATH   move PATH into the repo, add it to tracked, link + sync
#   sync         commit all changes, push if ahead
#   pull         sync, then clone or pull --rebase from origin, then link
: "${DOTS:=$HOME/dots}"
export GIT_TERMINAL_PROMPT=0

# Timer sync and rebuild pull can overlap -> serialise on one lock.
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/dotfiles.lock"
flock -w 120 9

paths() { grep -v -E '^\s*(#|$)' "$DOTS/tracked"; }

cmd_link() {
  local backup p src dst
  backup="$HOME/.local/state/dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
  while read -r p; do
    src="$DOTS/$p" dst="$HOME/$p"
    [ -e "$src" ] || { echo "skip $p: not in repo" >&2; continue; }
    [ "$(readlink "$dst" || true)" = "$src" ] && continue
    # First link on a machine: keep whatever was there instead of deleting it.
    if [ -e "$dst" ] || [ -L "$dst" ]; then
      mkdir -p "$(dirname "$backup/$p")"
      mv "$dst" "$backup/$p"
      echo "backed up ~/$p -> $backup/$p"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "linked ~/$p"
  done < <(paths)
}

cmd_sync() {
  local files
  cd "$DOTS"
  git add -A
  if ! git diff --cached --quiet; then
    files=$(git diff --cached --name-only)
    git commit -q -m "auto: $(wc -l <<<"$files") file(s): $(head -3 <<<"$files" | xargs -n1 basename | paste -sd, -)"
  fi
  if [ "$(git rev-list --count '@{u}..HEAD' 2>/dev/null || echo 1)" != 0 ]; then
    git push -q -u origin HEAD || echo "push failed (offline?), retrying next sync" >&2
  fi
}

cmd_pull() {
  if [ -d "$DOTS/.git" ]; then
    cmd_sync
    git -C "$DOTS" pull -q --rebase || echo "pull failed, linking local copy" >&2
  else
    git clone -q "$DOTS_REMOTE" "$DOTS"
  fi
  cmd_link
}

cmd_track() {
  local abs rel
  abs=$(realpath -s "$1")
  rel=${abs#"$HOME"/}
  [ "$rel" != "$abs" ] || { echo "not under \$HOME: $1" >&2; exit 1; }
  if grep -qxF "$rel" "$DOTS/tracked"; then echo "already tracked: $rel"; return; fi
  [ ! -e "$DOTS/$rel" ] || { echo "already in repo: $rel" >&2; exit 1; }
  mkdir -p "$(dirname "$DOTS/$rel")"
  mv "$abs" "$DOTS/$rel"
  echo "$rel" >>"$DOTS/tracked"
  cmd_link
  cmd_sync
}

case "${1:-}" in
  link | sync | pull) "cmd_$1" ;;
  track) cmd_track "${2:?usage: dotfiles track PATH}" ;;
  *) echo "usage: dotfiles {link|track PATH|sync|pull}" >&2; exit 2 ;;
esac
