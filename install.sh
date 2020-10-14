#!/usr/bin/env bash

die(){
  echo "!! $1 " >&2
  echo "!! -----------------------------" >&2
  exit 1
}

git version > /dev/null 2>&1 || die "git is not installed on this machine"
[[ -d "$HOME/.basher" ]] && die "basher is already installed on [$HOME/.basher]"

## install the scripts on ~/.basher
git clone https://github.com/basherpm/basher.git ~/.basher

## now check what shell is running
shell_type=$(basename "$SHELL")
case "$shell_type" in
bash)
    startup_script="$HOME/.bashrc"
    startup_type=simple
  ;;

zsh)
    startup_script="$HOME/.zshrc"
    startup_type=simple
  ;;

sh)
    startup_script="$HOME/.profile"
    startup_type=simple
  ;;

fish)
    startup_script="$HOME/.config/fish/config.fish"
    startup_type=fish
  ;;

*)
    startup_script=""
    startup_type=""
esac

[[ -n "$startup_script" && ! -f "$startup_script" ]] && die "startup script [$startup_script] does not exist"

basher_keyword="basher5ea843"
if [[ "$startup_type" == "simple" ]] ; then
  (
    echo "export PATH=\"$HOME/.basher/bin:$PATH\"   ##$basher_keyword"
    # shellcheck disable=SC2086
    echo "eval \"$(basher init - $shell_type)\"             ##$basher_keyword"
  ) >> "$startup_script"
elif [[ "$startup_type" == "fish" ]] ; then
  (
    echo "if test -d ~/.basher          ##$basher_keyword"
    echo "  set basher ~/.basher/bin    ##$basher_keyword"
    echo "end                           ##$basher_keyword"
    # shellcheck disable=SC2154
    echo "set -gx PATH $basher $PATH    ##$basher_keyword"
    echo "status --is-interactive; and . (basher init - $shell_type | psub)    ##$basher_keyword"
  ) >> "$startup_script"
fi

echo "basher is installed - open a new terminal window to start using it"