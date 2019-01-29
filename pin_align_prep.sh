#!/bin/bash
#
#  pin_align_prep.sh -- prepare a pin alignment image for
#                       comparison between 0 and 90 degree images
#                       H. J. Bernstein, 3 Jan 2019
#                       rev 16 Jan 2019
#
if [ "${1}xx" == "--help" ]; then
   echo "pin_align_prep.sh image_in image_out [base_image_out [sub_base_image_out]]"
   echo "        prepare a pin alignment image, image_in, for"
   echo "        comparison between -1 and 90 degree images"
   echo "        writing the resulting image to image_out"
   echo "        and optionally the 100 pixel strip in base_image_out"
   echo "        and optionally the 100 pixel strip in sub_base_image_out"
   echo "        assuming a 1280x1024 image and imgagemagick convert"
   echo "        in the PATH"
   exit
fi
tmp_dir=/tmp/${USER}_pin_align_$$
mkdir $tmp_dir
convert $1 -contrast  -contrast ${tmp_dir}/$1
convert ${tmp_dir}/$1 -crop 325x400+375+312 -canny 2x1 -negate -morphology Erode Octagon:1 -morphology Dilate Octagon:1 $2
if [ "${3}xx" != "xx" ]; then
  convert ${tmp_dir}/$1 -crop 100x400+650+312 -canny 2x1 -negate -morphology Erode Octagon:1 -morphology Dilate Octagon:1 $3
  if [ "${4}xx" != "xx" ]; then
    convert ${tmp_dir}/$1 -crop 100x400+750+312 -canny 2x1 -negate -morphology Erode Octagon:1 -morphology Dilate Octagon:1 $4
  fi
fi
convert $2 -hough-lines 20x20+180 MVG:"-"

