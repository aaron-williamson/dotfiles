#!/bin/bash

set -e

current_dir=$( cd "$( dirname ${BASH_SOURCE[0]} )" && pwd )

# Directory of config files
config_dir=$current_dir/configs

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
echo Linking dotfiles to home directory

for file in $(ls $config_dir); do
  link_dotfile $config_dir/$file
done

echo

# Link prezto files
prezto_dir=$config_dir/zprezto/runcoms
prezto_files=$(ls -1 $prezto_dir | grep -v README.md)

echo Initializing prezto files

for file in $prezto_files; do
  link_dotfile $prezto_dir/$file
done

echo

# Set up vim
echo Running vim setup
source $config_dir/vim/setup.sh

echo

echo All finished!
