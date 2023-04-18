#!/bin/bash
# 環境建置初始化


__filename=`realpath "$0"`
_dirsh=`dirname "$__filename"`


entryPath="$_dirsh/entry.vim"
configPath="$_dirsh/space/config"
localSitePath="$_dirsh/space/local/site"


plugPath="$_dirsh/space/local/site/autoload/plug.vim"
[ -f "$plugPath" ] \
  || curl -fSL "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" \
      --create-dirs -o "$plugPath"


# when use vim
if type vim &> /dev/null; then
  vimrcForVimPath="$HOME/.vimrc"
  if [ ! -f "$vimrcForVimPath" ]; then
    ln -sf "$entryPath" "$vimrcForVimPath"
  elif [ "`realpath "$vimrcForVimPath"`" != "$entryPath" ]; then
    echo "Pleace remove \"$vimrcForVimPath\""
  fi
fi

# when use neovim
if type nvim &> /dev/null; then
  if [ ! -d "$HOME/.config" ]; then
    mkdir -p "$HOME/.config"
  fi
  configForNvimPath="$HOME/.config/nvim"
  if [ ! -e "$configForNvimPath" ]; then
    ln -sf "$configPath" "$configForNvimPath"
  elif [ "`realpath "$configForNvimPath"`" != "$configPath" ]; then
    echo "Pleace remove \"$configForNvimPath\""
  fi

  if [ ! -d "$HOME/.local/share/nvim" ]; then
    mkdir -p "$HOME/.local/share/nvim"
  fi
  if [ ! -d "$localSitePath" ]; then
    mkdir -p "$localSitePath"
  fi
  localSiteForNvimPath="$HOME/.local/share/nvim/site"
  if [ ! -e "$localSiteForNvimPath" ]; then
    ln -sf "$localSitePath" "$localSiteForNvimPath"
  elif [ "`realpath "$localSiteForNvimPath"`" != "$localSitePath" ]; then
    echo "Pleace remove \"$localSiteForNvimPath\""
  fi
fi

