#!/bin/env bash

readarray -t lsp_paru <./lsp_paru.txt
paru -S --needed "${lsp_paru[@]}"

readarray -t lsp_ts_js <./lsp_ts_js.txt
if command -v pnpm >/dev/null 2>&1; then
  pnpm add -g "${lsp_ts_js[@]}"
elif command -v npm >/dev/null 2>&1; then
  npm i -g "${lsp_ts_js[@]}"
else
  echo "Neither pnpm or npm was found, the following LSPs are not installed:"
  printf "%s\n" "${lsp_ts_js[@]}"
fi

if command -v uv >/dev/null 2>&1; then
  uv tool install ruff@latest
  uv tool install basedpyright
  uv tool install pyrefly
else
  echo "uv was not found, the following LSPs are not installed:
  ruff (python linter and formatter)
  basedpyright (python lsp and typechecker)
  pyrefly (alternative python lsp)"
fi

if command -v cargo >/dev/null 2>&1; then
  cargo install --locked bacon bacon-ls
else
  echo "cargo was not found, the following LSPs are not installed:
  bacon
  bacon-ls"
fi

if command -v go >/dev/null 2>&1; then
  if ! command -v docker-language-server >/dev/null 2>&1; then
    go install github.com/docker/docker-language-server/cmd/docker-language-server@latest
  fi
  if ! command -v terraform-ls >/dev/null 2>&1; then
    go install github.com/hashicorp/terraform-ls@latest
  fi
  if ! command -v tflint >/dev/null 2>&1; then
    go install github.com/terraform-linters/tflint@latest
  fi
else
  echo "go was not found, the follow LSPs are not installed:
  docker-language-server"
fi
