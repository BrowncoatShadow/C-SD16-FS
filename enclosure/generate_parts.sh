#!/usr/bin/env bash
set -e

source_scad="enclosure.scad"
parts_dir="stl"

cd "$(dirname "$0")"

rm -rf "${parts_dir}"
mkdir "${parts_dir}"

openscad -D TopShell=1 -D BottomShell=1 -D FrontPanel=1 -D BackPanel=1 -o "${parts_dir}/full.stl" "${source_scad}"
openscad -D TopShell=0 -D BottomShell=1 -D FrontPanel=1 -D BackPanel=1 -o "${parts_dir}/topless.stl" "${source_scad}"
openscad -D TopShell=1 -D BottomShell=0 -D FrontPanel=0 -D BackPanel=0 -o "${parts_dir}/top_shell.stl" "${source_scad}"
openscad -D TopShell=0 -D BottomShell=1 -D FrontPanel=0 -D BackPanel=0 -o "${parts_dir}/bottom_shell.stl" "${source_scad}"
openscad -D TopShell=0 -D BottomShell=0 -D FrontPanel=1 -D BackPanel=0 -o "${parts_dir}/front_panel.stl" "${source_scad}"
openscad -D TopShell=0 -D BottomShell=0 -D FrontPanel=0 -D BackPanel=1 -o "${parts_dir}/back_pannel.stl" "${source_scad}"
