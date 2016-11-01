#!/bin/bash

set -e

function link_dotfile {
  dest="${HOME}/.$(basename $1)"
  if [[ -e $dest ]]; then
    echo File $dest exists, did not create link
  else
    echo Creating link from $1 to $dest
    ln -s $1 $dest
  fi
}

current_dir=$( cd "$( dirname ${BASH_SOURCE[0]} )" && pwd )

# Directory of config files
config_dir=$current_dir/configs

# Ensure we're in the dotfiles directory
cd $current_dir

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

# Check for neovim
echo Checking for neovim...
if (hash nvim 2>/dev/null); then
  has_neovim=true

  # If we have neovim, link the vim directory to the right place
  echo Neovim detected
  if [[ -n $XDG_CONFIG_HOME ]]; then
    neovim_conf_dir="$XDG_CONFIG_HOME"
  else
    neovim_conf_dir="$HOME/.config"
  fi

  if [[ -e "${neovim_conf_dir}/nvim" ]]; then
    echo Neovim directory found, skipping linking
  else
    echo Linking neovim configuration directory
    mkdir -p $neovim_conf_dir
    ln -s $current_dir $neovim_conf_dir/nvim
  fi
else
  echo No neovim detected
fi

# Set up vim
echo Running vim setup
source $config_dir/vim/setup.sh

echo

echo All finished!
