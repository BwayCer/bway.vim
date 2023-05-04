# MAINTAINER BwayCer (https://github.com/BwayCer/image.docker)


FROM alpine

# base: 0; plug: 1;
ARG tagLevel=1
ARG pkgName=neovim
ARG cmdName=nvim
ARG branch=main

# install dependency packages
RUN apk add --no-cache \
        grep curl bash bash-completion \
        git git-perl

RUN git clone https://github.com/BwayCer/bway.vim.git \
        --depth 1 --branch "$branch"

# install neovim & bway env
RUN apk add --no-cache "$pkgName" && \
    ln -sf "/usr/bin/$cmdName" /usr/bin/vi && \
    ./bway.vim/init.sh

# install plugin
RUN [ "$tagLevel" -ge 1 ] && { \
        apk add --no-cache ctags; \
        vi -c 'PlugInstall' -c 'qa!'; \
    } || :

