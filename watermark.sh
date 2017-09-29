#!/bin/bash

# This script tests a background image and watermark
# It sets the watermark, size, border and opacity using gsettings.

ROOT_UID=0    # To check if the user is root
E_ROOT=87     # Root Exit error

# variables
dir="$(pwd)"
background_image=""   # Stores the path to the background image file
watermark_file=""     # stores the path of the watermark file
opacity=""            # a number from 0 to 255
border=""             # standard is 40
size=""               # standard is 13

# Check if the user is root and exit if yes.
if [ "$UID" -eq "$ROOT_UID" ]
then
  echo "You can't run this script as root"
  exit $E_ROOT
fi

# Test whether the command has arguments
if [ -z "$1" ]
then
  echo "please add arguments"
  # need to add a proper message here

fi
echo $@

while [ $# -gt 0 ]
do
  case "$1" in
    -d) background_image="$dir/$2"; echo "--> $background_image"; shift;;
    -w) watermark_file="$dir/$2"; echo "$watermark_file"; shift;;
    -b) border=$2; echo "$border"; shift;;
    -o) opacity=$2; echo "$opacity"; shift;;
    -s) size=$2; echo  "$size"; shift;;
    -*)
        echo ""
        echo >&2 \
        "Invalid argument -> usage is: $0 [-d desktop_background_file][-w watermark_file] [-b border] [-o opacity] [-s size]"
        echo ""
        exit 1;;
     *) break;;
  esac
  shift
done


# --------------------------------------
# setup background image
if [  -n "$background_image" ]
then
  echo "Defining background image... "
  gsettings set org.gnome.desktop.background picture-uri "$dir/assets/$background_image"
fi

if [ -n "$watermark_file" ]
then
  echo "Defining watermark... "
  gsettings set org.gnome.shell.watermark watermark-file "$dir/assets/$watermark_file"
fi


# setup watermark border

if [ -n "$border" ]
then
  echo "Defining watermark border... "
  gsettings set org.gnome.shell.watermark watermark-border $border
fi

if [ -n "$size" ]
then
  echo "Defining watermark size"
  gsettings set org.gnome.shell.watermark watermark-size $size
fi

if [ -n "$opacity" ]
then
  # setup watermark OPACITY
  echo "Defining watermark opacity. "
  gsettings set org.gnome.shell.watermark watermark-opacity $opacity
fi
echo ""


# Echo the variables
# --------------------------------------
echo ""
echo "# --------------------------------------"
echo ""
echo "watermark: $file"
echo "size:      $size"
echo "border:    $border"
echo "opacity:   $opacity"
echo ""
echo "# --------------------------------------"
echo ""

exit 0
