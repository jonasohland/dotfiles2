#! /bin/bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "running on gnu/linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "running on darwin"
else
  echo "running on an unsupported operating system: $OSTYPE"
  exit 1
fi

if ! which git; then
  echo "git not installed"
  exit 1
fi

dotfiles_repo="$HOME/src/dotfiles"

if ! [[ -d "${dotfiles_repo}" ]]; then
  echo "bootstrapping dotfiles repository"
  mkdir -p "$HOME/src"

  if ! git clone --branch main git@github.com:jonasohland/dotfiles2.git "${dotfiles_repo}"; then exit 1; fi
fi

exec bash "${dotfiles_repo}/install.sh"
