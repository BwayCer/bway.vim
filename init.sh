#!/bin/bash
# 環境建置初始化


__filename=`realpath "$0"`
_dirsh=`dirname "$__filename"`


plugPath="$_dirsh/localShare/site/autoload/plug.vim"
[ -f "$plugPath" ] \
  || curl -L "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" \
      --create-dirs -o "$plugPath"

# when use vim
if type vim > /dev/null; then
  vimrcPath="$_dirsh/.vimrc"
  vimrcForVimPath="$HOME/.vimrc"
  if [ ! -f "$vimrcForVimPath" ]; then
    ln -sf "$vimrcPath" "$vimrcForVimPath"
  elif [ "`realpath "$vimrcForVimPath"`" != "$vimrcPath" ]; then
    echo "Pleace remove \"$vimrcForVimPath\""
  fi
fi

# when use neovim
if type nvim > /dev/null; then
  vimrcForNvimPath="$HOME/.config/nvim"
  if [ ! -e "$vimrcForNvimPath" ]; then
    ln -sf "$_dirsh" "$vimrcForNvimPath"
  elif [ "`realpath "$vimrcForNvimPath"`" != "$_dirsh" ]; then
    echo "Pleace remove \"$vimrcForNvimPath\""
  fi
fi

