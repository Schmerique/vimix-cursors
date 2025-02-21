#!/usr/bin/env bash

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/icons"
else
  DEST_DIR="$HOME/.local/share/icons"
  mkdir -p $DEST_DIR
fi

if [ -d "$DEST_DIR/Vimix Hyprcursors - Dark" ]; then
  rm -rf "$DEST_DIR/Vimix Hyprcursors - Dark"
fi

if [ -d "$DEST_DIR/Vimix Hyprcursors - Light" ]; then
  rm -rf "$DEST_DIR/Vimix Hyprcursors - Light"
fi

cp -r "hyprcursor/theme_Vimix Hyprcursors - Dark/" "$DEST_DIR/Vimix Hyprcursors - Dark"
cp -r "hyprcursor/theme_Vimix Hyprcursors - Light/" "$DEST_DIR/Vimix Hyprcursors - Light"

echo "Finished..."

