# This file does nothing on its own. It is meant to be read by the main
# init.sh script for the sake of functions

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

function inputrc_config {
  echo Linking inputrc dotfiles...
  link_dotfile $config_dir/inputrc
  echo Done inputrc setup
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

function ruby_config {
  echo Linking ruby dotfiles...
  link_dotfile $config_dir/irbrc
  link_dotfile $config_dir/gemrc
  echo Done ruby setup
  echo
}

function tmux_config {
  echo Linking tmux dotfiles...
  link_dotfile $config_dir/tmux.conf
  echo Done tmux setup
  echo
}

function vim_config {
  echo Linking vim dotfiles...
  link_dotfile $config_dir/vim
  echo Done vim setup
  echo
}

function vim_plugins_config {
  if [[ -z $NO_VIM_PLUGINS || $NO_VIM_PLUGINS -eq 0 ]]; then
    echo Running vim plugin setup...
    sh $config_dir/vim/plugin_setup.sh
  else
    echo "Error, NO_VIM_PLUGINS is ${NO_VIM_PLUGINS}"
    echo "Skipping vim plugin setup"
  fi
}
