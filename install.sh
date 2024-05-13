#! /bin/bash

script_dir=$(cd -- "$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")" &>/dev/null && pwd)

function install_package() {
  local package="${1}"

  package_name="$(basename "${package}")"
  echo "stowing package ${package_name}"

  stow_args+=("-t" "$(envsubst <"${package}/_target")")
  stow_args+=("-d" "$(dirname "${package}")")

  if [[ "${DRY_RUN}" = "1" ]]; then
    stow_args+=("-v1" "-n")
  fi

  stow_args+=("-R" "${package_name}")

  stow --ignore _target "${stow_args[@]}"
}

function install_all_packages() {
  for pkg in "${script_dir}/packages/"*; do
    install_package "$pkg"
  done
}

install_all_packages
