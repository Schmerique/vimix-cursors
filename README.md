# Vimix Cursors (Scalable)

This is a cursor theme inspired by Materia design and based on [capitaine-cursors](https://github.com/keeferrourke/capitaine-cursors), adapted to work with KDE's scalable cursors, supported since Plasma 6.2.

## Installation

### Prebuilt release

Download the latest vimix-cursors-scalable release and extract it to your preferred icons directory.

For local installation that is:

```bash
~/.local/share/icons/
```

For system-wide installation:

```bash
/usr/share/icons/
```

Then set the theme with your preferred desktop tools.

### Installing from source

#### Requirements

- `python3`
- `python-cairosvg`
- `xorg-xcursorgen`

The `build.sh` script will try install the dependencies if they aren't available. If that doesn't work, install them manually through your distributions package manager.

#### Build process

Run

```bash
./build.sh
```

This will build both the dark and light theme.

To install the built themes locally (in `~/.local/share/icons/`) run:

```bash
./install.sh
```

For a system-wide installation (in `/usr/share/icons/`) run it as root, e.g. with `sudo`:

```bash
sudo ./install.sh
```

## Preview

<p align="center">
    <img src="preview.png" width="45%" alt="Vimix Cursors - Dark preview on a light and dark background"/>
    <img src="preview-white.png" width="45%" alt="Vimix Cursors - Light preview on a light and dark background"/>
</p>
