#!/bin/bash

set -e

current_dir=$( cd "$( dirname ${BASH_SOURCE[0]} )" && pwd )

# Array of dotfiles to link
dotfiles="emacs.d
          gemrc
          gitconfig
          irbrc
          tmux.conf
          vim
          zprezto"

# Ensure we're in the dotfiles directory
cd $current_dir

function link_dotfile {
  dest="${HOME}/.$(basename $1)"
  if [ -e $dest ]; then
    echo File $dest exists, did not create link
  else
    echo Creating link from $1 to $dest
    ln -s $1 $dest
  fi
}

# Link the dotfiles
echo Linking dotfile directories to home

for file in $dotfiles; do
  link_dotfile $current_dir/$file
done

echo

# Link prezto files
prezto_dir=$current_dir/zprezto/runcoms
prezto_files=$(ls -1 $prezto_dir | grep -v README.md)

echo Initializing prezto files

for file in $prezto_files; do
  link_dotfile $prezto_dir/$file
done

echo

# Set up vim
echo Setting up vim
source vim/setup.sh
