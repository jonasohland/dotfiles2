#! /bin/bash

function help() {
  echo "download-and-install.sh [args]"
  echo "  -h, --help  Show this help"
  echo "  -y, --yes   Say yes to all prompts"
}

while [[ $# -gt 0 ]]; do
  case $1 in
  -y | --yes)
    yes_to_all=1
    shift
    ;;
  -h | --help)
    help
    exit 0
    shift
    ;;
  *)
    echo "unsupported argument: $1"
    exit 1
    ;;
  esac
done

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "running on gnu/linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "running on darwin"
else
  echo "running on an unsupported operating system: $OSTYPE"
  exit 1
fi

if which apt-get >/dev/null 2>&1; then
  pkgmgr="apt"
  packages=("stow" "git" "gettext" "curl" "lua5.1" "luarocks")
elif which pacman >/dev/null 2>&1; then
  pkgmgr="pacman"
  packages=("stow" "git" "gettext" "curl" "lua51" "luarocks")
else
  echo "no supported package manager found"
  exit 1
fi

echo "package manager is: ${pkgmgr}"

case "${pkgmgr}" in
apt)
  for pkg in "${packages[@]}"; do
    if ! dpkg-query -s "${pkg}" >/dev/null 2>&1; then
      pkg_missing+=("${pkg}")
    fi
  done
  ;;
pacman)
  for pkg in "${packages[@]}"; do
    if ! pacman -Qi "${pkg}" >/dev/null 2>&1; then
      pkg_missing+=("${pkg}")
    fi
  done
  ;;
esac

if [[ "${#pkg_missing[@]}" -gt 0 ]]; then
  echo "the following packages are missing and must be installed:" "${pkg_missing[@]}"

  if [[ "${yes_to_all}" = 1 ]]; then
    case "$pkgmgr" in
    apt) if ! sudo apt-get install -y "${pkg_missing[@]}"; then exit 1; fi ;;
    pacman) if ! sudo pacman -Syu "${pkg_missing[@]}"; then exit 1; fi ;;
    esac
  else
    read -p "install now? [Y/n]:" yn

    case "${yn}" in
    [Yy] | '')
      case "$pkgmgr" in
      apt) if ! sudo apt-get install -y "${pkg_missing[@]}"; then exit 1; fi ;;
      pacman) if ! sudo pacman -Syu "${pkg_missing[@]}"; then exit 1; fi ;;
      esac
      ;;
    [Nn]) exit 1 ;;
    *)
      echo "please answer 'y' or 'n'"
      exit 1
      ;;
    esac
  fi
fi

dotfiles_repo="$HOME/src/dotfiles"

if ! [[ -d "${dotfiles_repo}" ]]; then
  echo "bootstrapping dotfiles repository"
  mkdir -p "$HOME/src"

  if [[ "${USER}" = "ohlano" ]]; then
    if ! git clone --branch main git@github.com:jonasohland/dotfiles2.git "${dotfiles_repo}"; then exit 1; fi
  else
    if ! git clone --branch main https://github.com/jonasohland/dotfiles2.git "${dotfiles_repo}"; then exit 1; fi
  fi
fi

for installer in "${dotfiles_repo}/installers/"*; do
  installer_basename="$(basename "${installer}")"
  installer_name="${installer_basename%.*}"

  if [[ "${yes_to_all}" = 1 ]]; then
    if ! bash "${installer}"; then exit 1; fi
  else
    read -p "install ${installer_name} now? [Y/n]:" yn

    case "${yn}" in
    [Yy] | '')
      if ! bash "${installer}"; then exit 1; fi
      ;;
    [Nn]) exit 1 ;;
    *)
      echo "please answer 'y' or 'n'"
      exit 1
      ;;
    esac
  fi
done

exec bash "${dotfiles_repo}/install.sh" install
