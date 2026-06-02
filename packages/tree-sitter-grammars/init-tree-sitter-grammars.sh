#! /bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
echo "$SCRIPT_DIR"

# grammars to be downloaded from nvim-treesitter/nvim-treesitter github repo
GRAMMARS=(
  asm
  bash
  c
  cpp
  cmake
  css
  csv
  dockerfile
  fish
  go
  gomod
  gosum
  git_config
  git_rebase
  gitcommit
  gitignore
  hcl
  helm
  hlsl
  html
  http
  hyprlang
  java
  javascript
  json
  kotlin
  lua
  latex
  make
  markdown
  markdown_inline
  nginx
  nix
  objdump
  printf
  proto
  readline
  regex
  python
  rust
  ssh_config
  starlark
  strace
  terraform
  toml
  tmux
  tsx
  typescript
  vue
  yaml
  zig
)

# extra grammars from the internet
declare -A EXTRA_GRAMMARS=(
  ["stage_idl"]="git@bitbucket.org:riedelcommunications/tree-sitter-stage-idl.git"
)

NVIM_TREESITTER_REPO="nvim-treesitter/nvim-treesitter"
NVIM_TREESITTER_REVISION="4916d65"
QUERIES_DIR="$SCRIPT_DIR/queries"
PARSERS_LUA="$SCRIPT_DIR/parsers.lua"
GRAMMARS_DIR="$SCRIPT_DIR/grammars"
PARSERS_DIR="$SCRIPT_DIR/parser"

CC="${CC:-cc}"
CXX="${CXX:-c++}"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Downloading $NVIM_TREESITTER_REPO @$NVIM_TREESITTER_REVISION ..."
mkdir -p "$TMP_DIR/nvim-treesitter"
curl -fsSL "https://codeload.github.com/$NVIM_TREESITTER_REPO/tar.gz/$NVIM_TREESITTER_REVISION" |
  tar -xz -C "$TMP_DIR/nvim-treesitter" --strip-components=1

echo "Copying query configs into $QUERIES_DIR ..."
rm -rf "$QUERIES_DIR"
cp -r "$TMP_DIR/nvim-treesitter/runtime/queries" "$QUERIES_DIR"

echo "Copying parsers.lua into $SCRIPT_DIR ..."
cp "$TMP_DIR/nvim-treesitter/lua/nvim-treesitter/parsers.lua" "$PARSERS_LUA"

parse_install_info() {
  awk -v target="$1" '
        function qval(s) {
            if (match(s, /'\''[^'\'']*'\''/)) return substr(s, RSTART + 1, RLENGTH - 2)
            return ""
        }
        $0 == "  " target " = {" { found = 1; next }
        found && $0 == "    install_info = {" { ininfo = 1; next }
        ininfo {
            if ($0 == "    },") { ininfo = 0; next }
            if ($0 ~ /url = /)            url = qval($0)
            else if ($0 ~ /revision = /)  rev = qval($0)
            else if ($0 ~ /location = /)  loc = qval($0)
            next
        }
        found && $0 == "  }," { exit }
        # Separate with a non-whitespace unit-separator so that empty fields
        # (e.g. a missing location) survive read instead of collapsing.
        END { printf "%s\037%s\037%s\n", url, rev, loc }
    ' "$PARSERS_LUA"
}

compile_grammar() {
  local name="$1" grammar_dir="$2"
  local src_dir="$grammar_dir/src"
  local out="$PARSERS_DIR/$name.so"
  local obj_dir="$TMP_DIR/obj/$name"
  local -a objs=()
  local link="$CC"

  if [ ! -f "$src_dir/parser.c" ]; then
    echo "    error: '$name' has no src/parser.c, cannot compile" >&2
    return 1
  fi

  mkdir -p "$obj_dir"
  echo "    compiling $name.so ..."

  "$CC" -c -fPIC -O2 -I "$src_dir" -o "$obj_dir/parser.o" "$src_dir/parser.c"
  objs+=("$obj_dir/parser.o")

  if [ -f "$src_dir/scanner.c" ]; then
    "$CC" -c -fPIC -O2 -I "$src_dir" -o "$obj_dir/scanner.o" "$src_dir/scanner.c"
    objs+=("$obj_dir/scanner.o")
  elif [ -f "$src_dir/scanner.cc" ]; then
    "$CXX" -c -fPIC -O2 -I "$src_dir" -o "$obj_dir/scanner.o" "$src_dir/scanner.cc"
    objs+=("$obj_dir/scanner.o")
    link="$CXX"
  elif [ -f "$src_dir/scanner.cpp" ]; then
    "$CXX" -c -fPIC -O2 -I "$src_dir" -o "$obj_dir/scanner.o" "$src_dir/scanner.cpp"
    objs+=("$obj_dir/scanner.o")
    link="$CXX"
  fi

  "$link" -shared -o "$out" "${objs[@]}"
}

echo "Building ${#GRAMMARS[@]} parsers into $PARSERS_DIR ..."
rm -rf "$PARSERS_DIR"
mkdir -p "$PARSERS_DIR"

for name in "${GRAMMARS[@]}"; do
  IFS=$'\037' read -r url revision location < <(parse_install_info "$name")

  if [ -z "$url" ]; then
    echo "  warning: no install_info for '$name' in parsers.lua, skipping"
    continue
  fi

  echo "  $name ($url @ ${revision:0:12})"

  # Derive "owner/repo" from the GitHub URL and download the source tarball at
  # the pinned revision via curl instead of cloning (which is slow).
  repo="${url#https://github.com/}"
  repo="${repo%.git}"
  repo_dir="$TMP_DIR/grammars-src/$name"
  mkdir -p "$repo_dir"
  curl -fsSL "https://codeload.github.com/$repo/tar.gz/$revision" |
    tar -xz -C "$repo_dir" --strip-components=1

  src_dir="$repo_dir${location:+/$location}"

  # Some grammars commit only grammar.js and leave src/parser.c to be generated;
  # parsers.lua's "generate" flag does not reliably mark all of them. Check for
  # the generated source directly and run 'tree-sitter generate' when missing.
  if [ ! -f "$src_dir/src/parser.c" ]; then
    if command -v tree-sitter &>/dev/null; then
      echo "    running 'tree-sitter generate' ..."
      (cd "$src_dir" && tree-sitter generate)
    else
      echo "    warning: '$name' has no src/parser.c and the tree-sitter CLI is not installed" >&2
    fi
  fi

  compile_grammar "$name" "$src_dir"
done

if [ "${#EXTRA_GRAMMARS[@]}" -gt 0 ]; then
  echo "Building ${#EXTRA_GRAMMARS[@]} extra grammars ..."
  for name in "${!EXTRA_GRAMMARS[@]}"; do
    url="${EXTRA_GRAMMARS[$name]}"
    echo "  $name ($url)"

    repo_dir="$TMP_DIR/extra-src/$name"
    if ! git clone --quiet --depth 1 "$url" "$repo_dir"; then
      echo "    warning: failed to clone '$name', skipping" >&2
      continue
    fi

    # Generate src/parser.c from grammar.js if the repo only ships the grammar.
    if [ ! -f "$repo_dir/src/parser.c" ]; then
      if [ -f "$repo_dir/grammar.js" ] && command -v tree-sitter &>/dev/null; then
        echo "    running 'tree-sitter generate' ..."
        (cd "$repo_dir" && tree-sitter generate)
      fi
    fi

    if ! compile_grammar "$name" "$repo_dir"; then
      echo "    warning: failed to compile '$name', skipping" >&2
      continue
    fi

    # Install the grammar's own queries; nvim-treesitter has none for it.
    if [ -d "$repo_dir/queries" ]; then
      echo "    installing queries ..."
      rm -rf "${QUERIES_DIR:?}/$name"
      cp -r "$repo_dir/queries" "$QUERIES_DIR/$name"
    fi
  done
fi

echo "Pruning unused query languages ..."

declare -A keep_query=()
queue=("${GRAMMARS[@]}" "${!EXTRA_GRAMMARS[@]}")
while [ "${#queue[@]}" -gt 0 ]; do
  lang="${queue[0]}"
  queue=("${queue[@]:1}")
  [ -n "${keep_query[$lang]:-}" ] && continue
  keep_query["$lang"]=1
  lang_dir="$QUERIES_DIR/$lang"
  [ -d "$lang_dir" ] || continue
  while IFS= read -r parent; do
    [ -n "$parent" ] && queue+=("$parent")
  done < <(
    sed -nE 's/^;+[[:space:]]*inherits[[:space:]]*:?[[:space:]]*([a-z_,()]+).*/\1/p' \
      "$lang_dir"/*.scm 2>/dev/null | tr ',' '\n' | tr -d '() '
  )
done

for lang_dir in "$QUERIES_DIR"/*/; do
  lang=$(basename "$lang_dir")
  [ -n "${keep_query[$lang]:-}" ] || rm -rf "$lang_dir"
done

echo "Removing build-only files ..."
rm -rf "$GRAMMARS_DIR"
rm -f "$PARSERS_LUA"

echo "Done."
