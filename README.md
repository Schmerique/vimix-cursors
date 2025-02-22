# Vimix Hyprcursors
This is a Hyprcursor port of the Vimix cursors theme inspired by Materia design and based on [capitaine-cursors](https://github.com/keeferrourke/capitaine-cursors).

## Installation
Download the latest vimix-hyprcursors release and extract it to your icons directory.

For local installation (recommended):
```
~/.local/share/icons
```
For system-wide installation:
```
/usr/share/icons
```
Then set the theme. For Vimix Hyprcursors - Dark:
```
hyprctl setcursor "Vimix Hyprcursors - Dark" 32
```
For Vimix Hyprcursors - Light:
```
hyprctl setcursor "Vimix Hyprcursors - Light" 32
```
## Building from source
You'll find everything you need to build and modify this cursor set in
the `src/` directory. To build the hyprcursor theme from the SVG source
run:

```
./build.sh
```
The compiled cursor theme will be located in `build/`.
When built from source, the install script can be used. For local installation:

```
./install.sh
```
For system-wide installation:
```
sudo ./install.sh
```

### Build dependencies
- `python3`
- `xorg-xcursorgen`
- `python-cairosvg`
- `hyprcursor-util`
- `xcur2png`

#### ArchLinux/Manjaro:
`build.sh` will try to install these dependencies if they are not available. Alternatively run:

    pacman -S python3 xorg-xcursorgen python-cairosvg hyprcursor xcur2png

#### Other:
Search for the engines in your distributions repository or install the depends from source.

## Preview
![Vimix](preview.png)
![Vimix-white](preview-white.png)
