#!/bin/bash
# 環境建置初始化


__filename=`realpath "$0"`
_dirsh=`dirname "$__filename"`


tmpPlugPath="$_dirsh/autoload/plug.vim"
[ -f "$tmpPlugPath" ] \
    || curl -s "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" \
        > "$tmpPlugPath"

tmpOriginVimrcPath="$HOME/.vimrc"
tmpVimrcPath="$_dirsh/.vimrc"
[ -f "$tmpOriginVimrcPath" ] \
    && [ "`realpath "$tmpOriginVimrcPath"`" != "$tmpVimrcPath" ] \
    || ln -sf "$tmpVimrcPath" "$tmpOriginVimrcPath"

