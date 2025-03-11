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

rm -rf "${HOME}/.local/share/nvim"
mkdir -vp "${HOME}/.local/share/nvim"
tar -C "${HOME}/.local/share/nvim" -xf "${wd}/nvim.tar.gz"
rm "${wd}/nvim.tar.gz"

if [[ ! -f "${HOME}/.bashrc" ]]; then
  touch "${HOME}/.bashrc"
fi

if ! grep -q -F 'PATH="${PATH}:${HOME}/.local/share/nvim/nvim-linux64/bin"' "${HOME}/.bashrc"; then
  echo 'PATH="${PATH}:${HOME}/.local/share/nvim/nvim-linux64/bin"' >>"${HOME}/.bashrc"
fi
