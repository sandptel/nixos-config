{ runCommand, git, util-linux }:
# `nix flake check`: pull leaves an existing dir alone, link --force adopts it (backup +
# link), track moves a file in and pushes it. Fake $HOME + local bare remote, no network.
runCommand "dotfiles-test" { nativeBuildInputs = [ git util-linux ]; } ''
  dotfiles() { bash -euo pipefail ${./dotfiles.sh} "$@"; }
  export HOME=$TMPDIR/home XDG_RUNTIME_DIR=$TMPDIR DOTS_REMOTE=$TMPDIR/remote.git
  export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t
  mkdir -p $HOME

  git init -q --bare -b main $DOTS_REMOTE
  git clone -q $DOTS_REMOTE seed
  mkdir -p seed/.config/app && echo new > seed/.config/app/conf
  echo .config/app > seed/tracked
  git -C seed add -A && git -C seed commit -qm seed && git -C seed push -q origin main

  mkdir -p $HOME/.config/app && echo old > $HOME/.config/app/conf
  dotfiles pull
  [ ! -L $HOME/.config/app ] && grep -qx old $HOME/.config/app/conf
  dotfiles link --force
  [ "$(readlink $HOME/.config/app)" = $HOME/dots/.config/app ]
  grep -qx old $HOME/.local/state/dotfiles-backup/*/.config/app/conf
  grep -qx new $HOME/.config/app/conf

  echo hi > $HOME/.rc
  dotfiles track $HOME/.rc
  [ -L $HOME/.rc ] && grep -qx .rc $HOME/dots/tracked
  git -C $DOTS_REMOTE log --format=%s | grep -q '^auto: 2 file(s): \.rc,tracked$'

  dotfiles link | grep -q . && exit 1 # idempotent: nothing to do
  touch $out
''
