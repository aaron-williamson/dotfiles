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

# Different directories used in the script
config_dir=$current_dir/configs
template_dir=$current_dir/templates
script_dir=$current_dir/scripts

# Options to be set by command line args
exclude=false
force=false
interactive=false
only=false

# Runlist includes everything by default
all_configs="tmux inputrc prezto neovim vim vim_plugins ruby bash ag git"
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
  -i          | Interactive, prompt when file exists instead of just quitting
  -h          | Help, show this dialogue
  -m          | eMail to use for git config (Make sure to use quotes)
  -n          | Name to use for git config (Make sure to use quotes)
  -o [config] | Only perform configuration for this config

Configs:
  ag          - Silver searcher configuration
  bash        - Bash configuration
  git         - Git configuration
  inputrc     - Input configuration for terminals
  neovim      - Awesomer version of the awesome text editor
  prezto      - Zsh configuration suite
  ruby        - Ruby configuration
  tmux        - The terminal multiplexer
  vim         - Awesome text editor
  vim_plugins - Run the plugin_setup script to set up vim/neovim plugins
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

  echo "Error, argument -o/-e $1 invalid"
  usage
  exit 1
}

# Links the given file to the home directory
function link_dotfile {
  source=$1
  if [[ $# -eq 1 ]]; then
    dest="${HOME}/.$(basename $1)"
  else
    dest=$2
  fi

  if $force; then
    echo Forcing link from $source to $dest
    ln -f -s $source $dest
  elif [[ -e $dest ]] && $interactive; then
    prompt $dest && ln -f -s $source $dest
  elif [[ ! -e $dest ]]; then
    echo Creating link from $source to $dest
    ln -s $source $dest
  else
    echo File $dest exists, skipping link from $source to $dest
  fi
}

function template_dotfile {
  source=$1
  if [[ $# -eq 1 ]]; then
    dest="${HOME}/.$(basename $1)"
  else
    dest=$2
  fi

  if $force; then
    echo Forcing file $dest from template $source
    cat $1 | $script_dir/mo > $dest
  elif [[ -e $dest ]] && $interactive; then
    prompt $dest && (cat $1 | $script_dir/mo > $dest)
  elif [[ ! -e $dest ]]; then
    echo Creating file $dest from template $source
    cat $1 | $script_dir/mo > $dest
  else
    echo File $dest exists, skipping creation from template $source
  fi
}

# Configuration function
function configure {
  case $1 in
    ag)
      ag_config
      ;;
    bash)
      bash_config
      ;;
    git)
      git_config
      ;;
    inputrc)
      inputrc_config
      ;;
    neovim)
      neovim_config
      ;;
    prezto)
      prezto_config
      ;;
    ruby)
      ruby_config
      ;;
    tmux)
      tmux_config
      ;;
    vim)
      vim_config
      ;;
    vim_plugins)
      vim_plugins
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
function prezto_config {
  prezto_dir=$config_dir/zprezto/runcoms
  prezto_files=$(ls -1 $prezto_dir | grep -v README.md)

  echo Linking zprezto dotfiles...
  link_dotfile $config_dir/zprezto

  for file in $prezto_files; do
    link_dotfile $prezto_dir/$file
  done
  echo Done prezto setup
  echo
}

function vim_config {
  echo Linking vim dotfiles...
  link_dotfile $config_dir/vim
  echo Done vim setup
  echo
}

function vim_plugins {
  if [[ -z $NO_VIM_PLUGINS || $NO_VIM_PLUGINS -eq 0 ]]; then
    echo Running vim plugin setup...
    sh $config_dir/vim/plugin_setup.sh
  else
    echo "Error, NO_VIM_PLUGINS is ${NO_VIM_PLUGINS}"
    echo "Skipping vim plugin setup"
  fi
}

function tmux_config {
  echo Linking tmux dotfiles...
  link_dotfile $config_dir/tmux.conf
  echo Done tmux setup
  echo
}

function inputrc_config {
  echo Linking inputrc dotfiles...
  link_dotfile $config_dir/inputrc
  echo Done inputrc setup
  echo
}

function ag_config {
  echo Linking silver searcher dotfiles...
  link_dotfile $config_dir/agignore
  echo Done silver searcher setup
  echo
}

function bash_config {
  echo Linking bash dotfiles...
  link_dotfile $config_dir/bash_profile
  link_dotfile $config_dir/bashrc
  echo Done bash setup
  echo
}

function ruby_config {
  echo Linking ruby dotfiles...
  link_dotfile $config_dir/irbrc
  link_dotfile $config_dir/gemrc
  echo Done ruby setup
  echo
}

function neovim_config {
  if [[ -n $XDG_CONFIG_HOME ]]; then
    neovim_config_dir="$XDG_CONFIG_HOME"
  else
    neovim_config_dir="$HOME/.config"
  fi

  link_dotfile $config_dir/vim $neovim_config_dir/nvim
  echo Done neovim setup
  echo
}

function git_config {
  echo Creating git config based on template...

  # Make sure we have a name
  if [[ -z $git_name ]]; then
    echo "Please input the name you wish to use for git:"
    read git_name
  fi

  # Make sure we have an email
  if [[ -z $git_email ]]; then
    echo "Please input the email you wish to use for git:"
    read git_email
  fi

  # Check for git version (for push: simple)
  git_version=$(git --version | cut -d ' ' -f3)
  git_major=$(echo $git_version | cut -d '.' -f1)
  git_minor=$(echo $git_version | cut -d '.' -f2)

  if [[ $git_major -ge 2 ]] || [[ $git_major -eq 1 && $git_minor -ge 8 ]]; then
    # Set the push var
    export GIT_PUSH=$(cat <<EOF
[push]
  default = upstream
EOF
)
  fi

  # Set the name and email vars
  export GIT_NAME=$git_name
  export GIT_EMAIL=$git_email

  template_dotfile $template_dir/gitconfig

  echo Done git setup
  echo
}
### End configuration functions ###

# Main function starts here
# Ensure we're in the dotfiles directory
cd $current_dir

while getopts ":e:fhim:n:o:" opt; do
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
    i)
      interactive=true
      ;;
    m)
      git_email=$OPTARG
      ;;
    n)
      git_name=$OPTARG
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
