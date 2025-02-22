#!/usr/bin/python3
from send2trash import send2trash as s2t
from pathlib import Path as path
import os
import shutil
import json
import argparse

parser = argparse.ArgumentParser(
    prog="add_scalable_cursors",
    description="Adds scalable cursors to Vimix Cursors (and perhaps other cursor themes)")

parser.add_argument("-i", "--input", nargs=1, help="the input path, in case of vimix cursors called src")
parser.add_argument("-o", "--output", nargs=1, help="the theme path, in case of vimix cursors called dist(-white)", required=True)
parser.add_argument("-s", "--svg-sub-path", nargs=1, help="the subdirectory under input that houses the svgs that should be used, in case of vimix cursors called svg(-white)", required=True)
args = parser.parse_args()

theme_path = args.output[0]
xcursors_path = os.path.join(theme_path, "cursors")
scalable_cursors_path = os.path.join(theme_path, "cursors_scalable")
src_path = "src" if args.input == None else args.input[0]
svg_path = os.path.join(src_path, "svg" if args.svg_sub_path == None else args.svg_sub_path[0])
config_path = os.path.join(src_path, "config")
cursor_list_path = os.path.join(src_path, "cursorList")
animation_fps = 60
frame_delay = round(1000/animation_fps)

try:
    shutil.rmtree(scalable_cursors_path)
except FileNotFoundError:
    pass

# walk through all config files
for cursor_name in [ f.name.split(".")[0] for f in os.scandir(config_path) ]:
    cursor_path = os.path.join(scalable_cursors_path, cursor_name)

    # walk through lines of config file
    config_file = open(os.path.join(config_path, cursor_name + ".cursor"), "r")
    metadata = []
    for config_line in config_file:

        # add entry to dict
        config_line_parts = config_line.split()
        if config_line_parts[0] != "24":
            continue
        svg_name = config_line_parts[3].split("/")[1].split(".")[0] + ".svg"
        metadata.append({})
        metadata[-1]["filename"] = svg_name
        metadata[-1]["nominal_size"] = 24
        metadata[-1]["hotspot_x"] = float(config_line_parts[1])
        metadata[-1]["hotspot_y"] = float(config_line_parts[2])
        if len(config_line_parts) >= 5:
            metadata[-1]["delay"] = frame_delay
            
        # move svg to new or existing subdirectory in scalable_cursors_path
        path(cursor_path).mkdir(parents=True, exist_ok=True)
        shutil.copy(os.path.join(svg_path, svg_name), os.path.join(cursor_path, svg_name))
    config_file.close()

    # write dict to metadata.json
    metadata_json_file = open(os.path.join(cursor_path, "metadata.json"), "w", encoding="utf-8")
    json.dump(metadata, metadata_json_file, ensure_ascii=False, indent=4)
    metadata_json_file.close()

# walk through cursorList
cursor_list_file = open(cursor_list_path, "r")
for line in cursor_list_file:
    
    # create symlink
    cursor_names = line.split()
    try:
        os.symlink(cursor_names[1], os.path.join(scalable_cursors_path, cursor_names[0]), target_is_directory=True)
    except FileExistsError:
        print(cursor_names[0], "exists already: skipping")

print("Done")