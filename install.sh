#! /bin/bash

script_dir=$(cd -- "$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")" &>/dev/null && pwd)
function is_dry_run() {
  [[ "${DRY_RUN}" = 1 ]]
}

function install_package() {
  local package="${1}"

  target="$(envsubst <"${package}/_target")"
  package_name="$(basename "${package}")"

  if [[ -f "${package}/_host" ]]; then
    target_host="$(<"${package}/_host")"

    if [[ "${target_host}" != "$(</etc/hostname)" ]]; then
      echo "==> skipping package ${package_name}"
      return
    fi
  fi

  echo "==> stowing package ${package_name}"

  stow_args=()
  stow_args+=("-t" "${target}")
  stow_args+=("-d" "$(dirname "${package}")")

  if is_dry_run; then
    stow_args+=("-v1" "-n")
  fi

  stow_args+=("-R" "${package_name}")

  # create the target directory if it does not already exists
  if is_dry_run; then
    echo "mkdir -p" "${target}"
  else
    mkdir -p "${target}"
  fi

  stow --ignore _target --override=".*" "${stow_args[@]}" 2> >(sed -E "s@LINK: (.*)@LINK: ${target}/\1@g" | grep -v "simulation mode" >&2)
}

function install_all_packages() {
  for pkg in "${script_dir}/packages/"*; do
    install_package "$pkg"
  done
}

install_all_packages
