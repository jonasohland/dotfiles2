#! /bin/bash

neovim_version="0.9.5"

if [[ "$OSTYPE" = "linux-gnu" ]]; then
  download_url="https://github.com/neovim/neovim/releases/download/v${neovim_version}/nvim-linux64.tar.gz"
else
  download_url="https://github.com/neovim/neovim/releases/download/v${neovim_version}/nvim-macos.tar.gz"
fi

wd="$(mktemp -d)"

echo "downloading neovim from $download_url"
curl -#L -o "${wd}/nvim.tar.gz" "${download_url}"

sudo rm -rf "/opt/nvim"
sudo tar -C "/opt" -xf "${wd}/nvim.tar.gz"
