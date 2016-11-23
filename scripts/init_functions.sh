# This file does nothing on its own. It is meant to be read by the main
# init.sh script for the sake of functions

# argument_check
# Params:
#   $1 - The argument you wish to check
#
# This function will check the argument given against the list of configs
# and ensure that it is contained within that list
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

# run_config
# Params:
#   $1 - The configuration argument you wish to run
#
# This function will parse nicer input options and run the appropriate
# configure function (these can be found in config_functions.sh)
function run_config {
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
      vim_plugins_config
      ;;
  esac
}

# prompt
# Params:
#   $1 - The file to use in the prompt messages
#
# This function prompts the user about whether they would like to over write
# the given file or not, returning 0 if they choose yes, and 1 if they choose
# no.
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

# link_dotfile
# Params:
#   $1 - The source file to link
#   $2 - The destination to link the file to [optional]
#
# This function links the given source file to the home directory with a
# prepended dot, or it links to the given destination
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

# template_dotfile
# Params:
#   $1 - The source template to use
#   $2 - The destination of the resulting file [optional]
#
# This function reads the template given, and creates a file from that
# template either in the home directory, prepended with a dot, or at the
# given destination. Uses the moustache templating engine which can be found
# in the scripts directory: scripts/mo. More details about mo can be found
# in its git repository at: https://github.com/tests-always-included/mo
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

# exclude_run
# Params:
#   $1 - The item to exclude from the run list
#
# This function excludes the given item from the run list for the current run
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

# only_run
# Params:
#   $1 - The config to only run
#
# This function will adjust the runlist such that it will only run the given
# config. If other configs have already been given in this way, then it will
# append them to the list to run.
function only_run {
  if $only; then
    runlist="${runlist} $1"
  else
    only=true
    runlist="${1}"
  fi
}

# run_setup
# Params:
#   None
#
# This function will take the items in runlist, and pass them to the
# configure function in order.
function run_setup {
  for item in $runlist; do
    run_config $item
  done
}

# usage
# Params:
#   None
#
# This function will print a usage message
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

Third party acknowledgements:

This product includes software developed by contributors. Specifically mo,
the moustache templating engine written completely in bash. For more
information, you can look here: https://github.com/tests-always-included/mo
EOF
}
