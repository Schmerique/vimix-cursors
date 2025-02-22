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

if [ -d "$DEST_DIR/vimix-cursors-dark-scalable" ]; then
  rm -rf "$DEST_DIR/vimix-cursors-dark-scalable"
fi

if [ -d "$DEST_DIR/vimix-cursors-light-scalable" ]; then
  rm -rf "$DEST_DIR/vimix-cursors-light-scalable"
fi

cp -r dist-dark/ $DEST_DIR/vimix-cursors-dark-scalable
cp -r dist-light/ $DEST_DIR/vimix-cursors-light-scalable

echo "Finished..."

