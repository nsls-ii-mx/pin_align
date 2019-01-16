#!/bin/bash
#
#  pin_align_prep.sh -- prepare a pin alignment image for
#                       comparison between 0 and 90 degree images
#                       H. J. Bernstein, 3 Jan 2019
#
if [ "${1}xx" == "--help" ]; then
   echo "pin_align_prep.sh image_in image_out"
   echo "        prepare a pin alignment image, image_in, for"
   echo "        comparison between 0 and 90 degree images"
   echo "        writing the resulting image to image_out"
   echo "        assuming a 1280x1024 image and imgagemagick convert"
   echo "        in the PATH"
   exit
fi
tmp_dir=/tmp/${USER}_pin_align_$$
mkdir $tmp_dir
convert $1 -contrast -contrast -contrast ${tmp_dir}/$1
convert ${tmp_dir}/$1 -canny 2x1 -negate -crop 375x400+375+312 -morphology Erode Octagon:7 -morphology Dilate Octagon:10 $2
convert $2 -hough-lines 20x20+180 MVG:"-"

