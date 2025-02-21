#!/usr/bin/env bash

# check command avalibility
has_command() {
  "$1" -v $1 > /dev/null 2>&1
}

if [ ! "$(which hyprcursor-util 2> /dev/null)" ]; then
  echo hyprcursor-util needs to be installed to generate hyprcursors.
  if has_command pacman; then
    sudo pacman -S --noconfirm hyprcursor
  else exit 1
  fi
fi

if [ ! "$(which xcur2png 2> /dev/null)" ]; then
  echo xcur2png needs to be installed to generate hyprcursors.
  if has_command pacman; then
    sudo pacman -S --noconfirm xcur2png
  else exit 1
  fi
fi

if [ ! "$(which xcursorgen 2> /dev/null)" ]; then
  echo xorg-xcursorgen needs to be installed to generate the cursors.
  if has_command zypper; then
    sudo zypper in xorg-xcursorgen
  elif has_command apt; then
    sudo apt install xorg-xcursorgen
  elif has_command dnf; then
    sudo dnf install -y xorg-xcursorgen
  elif has_command dnf; then
    sudo dnf install xorg-xcursorgen
  elif has_command pacman; then
    sudo pacman -S --noconfirm xorg-xcursorgen
  else exit 1
  fi
fi

if [ ! "$(which cairosvg 2> /dev/null)" ]; then
  echo xorg-xcursorgen needs to be installed to generate png files.
  if has_command zypper; then
    sudo zypper in python-cairosvg
  elif has_command apt; then
    sudo apt install python-cairosvg
  elif has_command dnf; then
    sudo dnf install -y python-cairosvg
  elif has_command dnf; then
    sudo dnf install python-cairosvg
  elif has_command pacman; then
    sudo pacman -S --noconfirm python-cairosvg
  else exit 1
  fi
fi

function create {
	cd "$SRC"
	mkdir -p x1 x1_25 x1_5 x2
	cd "$SRC"/$1
	find . -name "*.svg" -type f -exec sh -c 'echo -e "generating ${0%.svg}.png 32" && cairosvg -f png -o "../x1/${0%.svg}.png" --output-width 32 --output-height 32 $0' {} \;
	find . -name "*.svg" -type f -exec sh -c 'echo -e "generating ${0%.svg}.png 40" && cairosvg -f png -o "../x1_25/${0%.svg}.png" --output-width 40 --output-height 40 $0' {} \;
	find . -name "*.svg" -type f -exec sh -c 'echo -e "generating ${0%.svg}.png 48" && cairosvg -f png -o "../x1_5/${0%.svg}.png" --output-width 48 --output-height 48 $0' {} \;
	find . -name "*.svg" -type f -exec sh -c 'echo -e "generating ${0%.svg}.png 64" && cairosvg -f png -o "../x2/${0%.svg}.png" --output-width 64 --output-height 64 $0' {} \;

	cd $SRC

	# generate cursors
	if [[ "$THEME" =~ White$ ]]; then
		BUILD="$SRC"/../build/xcursors/dist-white
	else BUILD="$SRC"/../build/xcursors/dist
	fi

	OUTPUT="$BUILD"/cursors
	ALIASES="$SRC"/cursorList

	if [ ! -d "$OUTPUT" ]; then
		mkdir -p "$OUTPUT"
	fi

	echo -ne "Generating cursor theme...\\r"
	for CUR in config/*.cursor; do
		BASENAME="$CUR"
		BASENAME="${BASENAME##*/}"
		BASENAME="${BASENAME%.*}"

		xcursorgen "$CUR" "$OUTPUT/$BASENAME"
	done
	echo -e "Generating cursor theme... DONE"

	cd "$OUTPUT"

	#generate aliases
	echo -ne "Generating shortcuts...\\r"
	while read ALIAS; do
		FROM="${ALIAS#* }"
		TO="${ALIAS% *}"

		if [ -e $TO ]; then
			continue
		fi
		ln -sr "$FROM" "$TO"
	done < "$ALIASES"
	echo -e "Generating shortcuts... DONE"

	cd "$PWD"

	echo -ne "Generating Theme Index...\\r"
	INDEX="$OUTPUT/../index.theme"
	if [ ! -e "$OUTPUT/../$INDEX" ]; then
		touch "$INDEX"
		echo -e "[Icon Theme]\nName=$THEME\n" > "$INDEX"
	fi
	echo -e "Generating Theme Index... DONE"
}

# generate pixmaps from svg source
SRC=$PWD/src
THEME="Vimix Cursors"

create svg

THEME="Vimix Cursors - White"

create svg-white

cd ../../../..

echo "$PWD"

mkdir -p build/working-state

hyprcursor-util --extract "build/xcursors/dist" --output "build/working-state"
hyprcursor-util --extract "build/xcursors/dist-white" --output "build/working-state"

rm build/working-state/extracted_dist/manifest.hl
cp manifest-dark.hl build/working-state/extracted_dist/manifest.hl
rm build/working-state/extracted_dist-white/manifest.hl
cp manifest-light.hl build/working-state/extracted_dist-white/manifest.hl

./replace_cursor_images.py "src/svg" "build/working-state/extracted_dist/hyprcursors"
./replace_cursor_images.py "src/svg-white" "build/working-state/extracted_dist-white/hyprcursors"

hyprcursor-util --create "build/working-state/extracted_dist" --output "build"
hyprcursor-util --create "build/working-state/extracted_dist-white" --output "build"
