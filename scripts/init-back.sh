#!/usr/bin/env bash
set -euo pipefail

ENV="${1:-dev}"
ROOT_ENV=".env"
TEMPLATE="src/back/.env.example"
TARGET="src/back/.env"

cd "$(dirname "$0")/.."

if [ ! -f "$ROOT_ENV" ]; then
  echo "Error: Root $ROOT_ENV not found. Run scripts/init.sh $ENV first."
  exit 1
fi

if [ ! -f "$TEMPLATE" ]; then
  echo "Error: $TEMPLATE not found"
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

TMP=$(mktemp)
cp "$TEMPLATE" "$TMP"

while IFS='=' read -r key value; do
  [[ -z "$key" || "$key" =~ ^# ]] && continue
  sed -i "s|{${key}}|${value}|g" "$TMP"
done < "$ROOT_ENV"

cp "$TMP" "$TARGET"
rm "$TMP"

echo "Backend environment '$ENV' initialized. Created $TARGET from $TEMPLATE"
