#!/usr/bin/env bash
# 建立映像文件

set -e


__filename=`realpath "$0"`
_dirsh=`dirname "$__filename"`


cd "$_dirsh"

cmdList=(
  docker build -t bwaycer/vim:base-neo \
  --build-arg tagLevel=0 \
  --build-arg pkgName=neovim \
  --build-arg cmdName=nvim \
  -f Dockerfile  .
)
echo "\$ ${cmdList[*]}"
"${cmdList[@]}"

cmdList=(
  docker build -t bwaycer/vim:plug-neo \
  --build-arg tagLevel=1 \
  --build-arg pkgName=neovim \
  --build-arg cmdName=nvim \
  -f Dockerfile  .
)
echo "\$ ${cmdList[*]}"
"${cmdList[@]}"

cmdList=(
  docker build -t bwaycer/vim:base \
  --build-arg tagLevel=0 \
  --build-arg pkgName=vim \
  --build-arg cmdName=vim \
  -f Dockerfile  .
)
echo "\$ ${cmdList[*]}"
"${cmdList[@]}"

cmdList=(
  docker build -t bwaycer/vim:plug \
  --build-arg tagLevel=1 \
  --build-arg pkgName=vim \
  --build-arg cmdName=vim \
  -f Dockerfile  .
)
echo "\$ ${cmdList[*]}"
"${cmdList[@]}"

