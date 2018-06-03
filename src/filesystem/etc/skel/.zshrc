TERM=xterm-256color

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="spaceship"

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
# vi-mode
  encode64
  emoji
  ubuntu
)

SPACESHIP_PROMPT_ORDER=(
  time
  user
  dir
  host
  git
  hg
  package
  node
  ruby
  elixir
  xcode
  swift
  golang
  php
  rust
  haskell
  julia
  docker
  aws
  venv
  conda
  pyenv
  dotnet
  ember
  kubecontext
  exec_time
  line_sep
# battery
  vi_mode
  jobs
  exit_code
  char
)

source $ZSH/oh-my-zsh.sh
source $HOME/.zsh_envs
source $HOME/.zsh_aliases
source $HOME/.oh-my-zsh/custom/themes/spaceship.zsh-theme
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || true
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || true

fortune | cowsay
echo && ls
