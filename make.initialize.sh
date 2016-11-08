#!/bin/bash
# This script automatically configures my dotfiles
# It's organized such that there's a function for each configuration
# to be performed, and you can include/exclude these options with
# arguments, with the default being to run all of them.


# Process for adding a config to this script:
# 1. Add a function for it
# 2. Add it's name to usage, and the all_configs list
# 3. Add a case for it in the configure function

set -e

current_dir=$( cd "$( dirname ${BASH_SOURCE[0]} )" && pwd )

# Directory of config files
config_dir=$current_dir/configs

# Do not force by default
force=false

# Check for neovim by default
neovim_check=true

# Options to be set by command line args
only=false
exclude=false

# Runlist includes everything by default
all_configs="tmux prezto vim neovim git ruby bash ag"
runlist="${all_configs}"


function usage {
  cat >&2 <<EOF
Usage: $0 [options]

Note: You can chain multiple options together, for example:

  $0 -e prezto -e vim

  Will exclude both prezto and vim configuration, and

  $0 -o prezto -o vim

  Will only run prezto and vim configurations. However you
  cannot use both -o and -e in one command.

Options:
  -e [config] | Exclude this config from the run
  -f          | Force linking, this will overwrite any files
  -h          | Help, show this dialogue
  -o [config] | Only perform configuration for this config

Configs:
  tmux   - The terminal multiplexer
  prezto - Zsh configuration suite
  vim    - Awesome text editor
  neovim - Awesomer version of the awesome text editor
  git    - Git configuration
  ruby   - Ruby configuration
  bash   - Bash configuration
  ag     - Silver searcher configuration
EOF
}

function prompt {
  while true; do
    read -p "File $1 exists, would you like to overwrite it? [y/n] " yn
    case $yn in
      [yY])
        echo "Overwriting $1 and proceeding"
        return 0
        ;;
      [nN])
        echo "Will not overwrite ${1}, continuing..."
        return 1
        ;;
      *)
        echo "Please enter y or n"
        ;;
    esac
  done
}

function argument_check {
  for item in $all_configs; do
    if [[ $item == $1 ]]; then
      return 0
    fi
  done

  echo "Error, argument -o $1 invalid"
  usage
  exit 1
}

# Links the given file to the home directory
function link_dotfile {
  dest="${HOME}/.$(basename $1)"
  if $force; then
    echo Forcing link from $1 to $dest
    ln -f -s $1 $dest
  elif [[ -e $dest ]] && prompt $dest; then
    ln -f -s $1 $dest
  elif [[ ! -e $dest ]]; then
    echo Creating link from $1 to $dest
    ln -s $1 $dest
  fi
}

# Configuration function
function configure {
  case $1 in
    ag)
      ag
      ;;
    bash)
      bash
      ;;
    git)
      git
      ;;
    neovim)
      neovim
      ;;
    prezto)
      prezto
      ;;
    ruby)
      ruby
      ;;
    tmux)
      tmux
      ;;
    vim)
      vim
      ;;
  esac
}

function exclude_run {
  exclude=true

  temp_runlist=""

  for item in $runlist; do
    if [[ $item != $1 ]]; then
      temp_runlist="${temp_runlist} $item"
    fi
  done

  runlist=$temp_runlist
}

function only_run {
  if $only; then
    runlist="${runlist} $1"
  else
    only=true
    runlist="${1}"
  fi
}

function run_setup {
  for item in $runlist; do
    configure $item
  done
}


### Begin configuration functions ###
function prezto {
  prezto_dir=$config_dir/zprezto/runcoms
  prezto_files=$(ls -1 $prezto_dir | grep -v README.md)

  echo Linking zprezto dotfiles...
  link_dotfile zprezto

  for file in $prezto_files; do
    link_dotfile $prezto_dir/$file
  done
  echo Done prezto setup
  echo
}

function vim {
  echo Linking vim dotfiles...
  link_dotfile $config_dir/vim

  echo Running vim setup...
  source $config_dir/vim/setup.sh
  echo Done vim setup
  echo
}

function tmux {
  echo Linking tmux dotfiles...
  link_dotfile $config_dir/tmux.conf
  echo Done tmux setup
  echo
}

function ag {
  echo Linking silver searcher dotfiles...
  link_dotfile $config_dir/agignore
  echo Done silver searcher setup
  echo
}

function bash {
  echo Linking bash dotfiles...
  link_dotfile $config_dir/bash_profile
  link_dotfile $config_dir/bashrc
  echo Done bash setup
  echo
}

function ruby {
  echo Linking ruby dotfiles...
  link_dotfile $config_dir/irbrc
  link_dotfile $config_dir/gemrc
  echo Done ruby setup
  echo
}

function neovim {
  if [[ -n $XDG_CONFIG_HOME ]]; then
    neovim_conf_dir="$XDG_CONFIG_HOME"
  else
    neovim_conf_dir="$HOME/.config"
  fi

  if $force; then
    echo "Forcing link from ${config_dir}/vim to ${neovim_conf_dir}/nvim"
    mkdir -p $neovim_conf_dir
    ln -f -s $config_dir/vim $neovim_conf_dir/nvim
  elif [[ -e "${neovim_conf_dir}/nvim" ]] && prompt "${neovim_conf_dir}/nvim"; then
    mkdir -p $neovim_conf_dir
    ln -f -s $config_dir/vim $neovim_conf_dir/nvim
  elif [[ ! -e "${neovim_conf_dir}/nvim" ]]; then
    echo "Linking ${config_dir}/vim to ${neovim_conf_dir}/nvim"
  fi
  echo Done neovim setup
  echo
}

function git {
  echo Linking git dotfiles...
  link_dotfile $config_dir/gitconfig
  echo Done git setup
  echo
}
### End configuration functions ###

# Main function starts here
# Ensure we're in the dotfiles directory
cd $current_dir

while getopts ":e:fho:" opt; do
  case $opt in
    e)
      argument_check $OPTARG
      if $only; then
        echo "Error, cannot run with -o and -e"
        usage
        exit 1
      fi
      exclude_run $OPTARG
      ;;
    f)
      force=true
      ;;
    h)
      usage
      exit 0
      ;;
    o)
      argument_check $OPTARG
      if $exclude; then
        echo "Error, cannot run with -o and -e"
        usage
        exit 1
      fi
      only_run $OPTARG
      ;;
    \?)
      echo "Unknown option -$OPTARG" >&2
      usage
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument"
      usage
      exit 1
      ;;
  esac
done

# Run now that we've gathered the options
run_setup

echo All finished!
