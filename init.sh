#!/bin/bash
# This script automatically configures my dotfiles
# It's organized such that there's a function for each configuration
# to be performed, and you can include/exclude these options with
# arguments, with the default being to run all of them.
# For more information see the separate files init_functions.sh
# and config_functions.sh

# Process for adding a config to this script:
# 1. Add a function for it to scripts/config_functions
# 2. Add it's name to the all_configs list
# 3. Add a case for it in the run_config function in scripts/init_functions.sh
# 4. Add an explanation for it in the usage function in scripts/init_functions.sh

set -e

# ~~~ Variables ~~~
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

# ~~~ End variables ~~~

# Source the files containing our functions
. scripts/init_functions.sh
. scripts/config_functions.sh

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
