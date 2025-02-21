#!/usr/bin/python3
from send2trash import send2trash as s2t
import os
import re
import shutil
import sys

hyprcursors_path = "build/dark/hyprcursors" if len(sys.argv) < 3 else sys.argv[2]
svg_path = "src/svg" if len(sys.argv) < 2 else sys.argv[1]
animation_fps = 60
frame_delay = round(1000/animation_fps)

# walk through all hyprcursors subdirectories
for cursor in [ f.name for f in os.scandir(hyprcursors_path) if f.is_dir() ]:
    cursor_path = hyprcursors_path + "/" + cursor

    # move existing .png and .svg files in every subdirectory to trash
    for f in os.scandir(cursor_path):
        if re.findall(r".*\.svg|.*\.png", f.name):
            s2t(cursor_path + "/" + f.name)
    
    # read meta.hl
    meta = open(cursor_path + "/meta.hl", "r")

    # discard lines starting with "define_size"
    lines = []
    for l in meta:
        if not re.findall(r"^define_size", l) and not l == "\n":
            lines.append(l)
    meta.close()
    
    # walk over all cursor svgs with same name as directory
    images = [ f.name for f in os.scandir(svg_path) if re.findall(r"^" + cursor + r"[-]?[0-9]?[0-9]?\.svg", f.name) ]
    images.sort()
    for image in images:
        shutil.copyfile(svg_path + "/" + image, cursor_path + "/" + image)
        lines.append("define_size = 48, " + image + ", " + str(frame_delay) + "\n")

    # write new meta
    meta = open(cursor_path + "/meta.hl", "w")
    meta.writelines(lines)