#!/usr/bin/env bash
set -euo pipefail

ENV="${1:-dev}"
TARGET=".env"

cd "$(dirname "$0")/.."

if [ "$ENV" = "dev" ]; then
  ENV_FILE=".env.example"
else
  ENV_FILE=".env.${ENV}.example"
fi

if [ ! -f "$ENV_FILE" ]; then
  echo "Error: $ENV_FILE not found"
  exit 1
fi

if [ -f "$TARGET" ]; then
  echo "Warning: $TARGET already exists"
  read -p "Overwrite? [y/N] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
  fi
fi

cp "$ENV_FILE" "$TARGET"
echo "Environment '$ENV' initialized. Copied $ENV_FILE -> $TARGET"
