#!/usr/bin/env bash
# Conda-style entry-point scripts (jupyter, jupyter-lite, ...) bake an
# absolute shebang path to this env's interpreter. If this submodule (or
# the whole repo) is moved or freshly cloned to a different absolute path,
# those shebangs go stale even though pixi's lock-file hash is unchanged --
# so `pixi run` thinks the env is fine and won't reinstall on its own,
# and every task fails with "Error launching 'jupyter': No such file or
# directory". This detects that by actually invoking the binary, and
# reinstalls the env (a local, gitignored build artifact) when it's
# broken or missing.
set -euo pipefail
cd "$(dirname "$0")/.."   # docs/jupyterlite

JUPYTER=".pixi/envs/default/bin/jupyter"

if [ -x "$JUPYTER" ] && "$JUPYTER" --version >/dev/null 2>&1; then
  exit 0
fi

echo "==> jupyterlite pixi env is missing or stale (moved/cloned path?) -- reinstalling"
rm -rf .pixi
pixi install
