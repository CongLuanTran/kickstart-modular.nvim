#!/bin/env bash

readarray -t lsp_list <./lsp_paru.txt
paru -S --needed "${lsp_list[@]}"

if command -v pnpm >/dev/null 2>&1; then
  pnpm add -g @vtsls/language-server vim-language-server @olrtg/emmet-language-server oxlint oxfmt @fsouza/prettierd prettier
elif command -v npm >/dev/null 2>&1; then
  npm i -g @vtsls/language-server vim-language-server @olrtg/emmet-language-server oxlint oxfmt @fsouza/prettierd prettier
else
  echo "Neither pnpm or npm was found, the following LSPs are not installed:
  vtsls (for typescript/javascript)
  vim-language-server
  emmet-language-server
  oxlint
  oxfmt"
fi

if command -v uv >/dev/null 2>&1; then
  uv tool install ruff@latest
  uv tool install basedpyright
else
  echo "uv was not found, the following LSPs are not installed:
  ruff (python linter and formatter)
  basedpyright (python lsp and typechecker)"
fi

if command -v cargo >/dev/null 2>&1; then
  cargo install --locked bacon bacon-ls
else
  echo "cargo was not found, the following LSPs are not installed:
  bacon
  bacon-ls"
fi
