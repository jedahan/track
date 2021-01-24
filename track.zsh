err() { echo "$@" >&2; return 1 }

track() ( set -e
  (( $# )) || err "missing <path/to/file>"
  local realpath="$HOME/${@##${HOME}}"
  local destpath="${realpath/${HOME}/${HOME}/.dotfiles}"

  test -h "$realpath" && err "track: refusing to overwrite symlink $realpath"
  mkdir -p $(dirname $destpath) 
  mv -i "$realpath" "$destpath" 
  ln -sf "$destpath" "$realpath"

  local filename="${destpath##${HOME}/.dotfiles/}"
  git -C "$HOME/.dotfiles" add "$filename"
  git -C "$HOME/.dotfiles" commit --message "track $filename"
)

untrack() ( set -e
  (( $# )) || err "missing <path/to/file>"
  local realpath="$HOME/${@##${HOME}}"
  local destpath="${realpath/${HOME}/${HOME}/.dotfiles}"

  test -f "$realpath" && err "untrack: refusing to overwrite file $realpath"
  mkdir -p $(dirname $realpath) 
  mv -i "$destpath" "$realpath"

  local filename="${destpath##${HOME}/.dotfiles/}"
  git -C "$HOME/.dotfiles" add "$filename"
  git -C "$HOME/.dotfiles" commit --message "untrack $filename"
)
