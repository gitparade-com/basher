#!/usr/bin/env bash

die() {
  echo "!! $1 " >&2
  echo "!! -----------------------------" >&2
  exit 1
}

## stop if basher is already installed
[[ ! -d "$HOME/.basher" ]] && die "basher doesn't seem to be installed on [$HOME/.basher]"
echo ". remove basher code and installed packages"
sleep 1
basher list
rm -fr "$HOME/.basher"

## now check what shell is running
shell_type=$(basename "$SHELL")
case "$shell_type" in
bash)  startup_type="simple" ; startup_script="$HOME/.bashrc" ;;
zsh)   startup_type="simple" ; startup_script="$HOME/.zshrc"  ;;
sh)    startup_type="simple" ; startup_script="$HOME/.profile";;
fish)  startup_type="fish"   ; startup_script="$HOME/.config/fish/config.fish"  ;;
*)     startup_type="?"      ; startup_script="" ;   ;;
esac

## startup script should exist already
[[ -n "$startup_script" && ! -f "$startup_script" ]] && die "startup script [$startup_script] does not exist"

## basher_keyword will allow us to remove the lines upon uninstall
basher_keyword="basher5ea843"

if grep -q "$basher_keyword" "$startup_script" ; then
  echo ". remove basher from startup script [$startup_script]"
  sleep 1
  temp_file="$startup_script.temp"
  cp "$startup_script" "$temp_file"
  < "$temp_file" grep -v "$basher_keyword" > "$startup_script"
  rm "$temp_file"
else
  if grep -q basher "$startup_script" ; then
    grep basher "$startup_script"
    die "Can't auto-remove the lines from $(basename $startup_script) -please do so manually "
  fi
fi

## script is finished
echo "basher is uninstalled"
