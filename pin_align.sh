#!/bin/bash
#
#  pin_align.sh -- ccmparison 0 and 90 degree images
#                       H. J. Bernstein, 3 Jan 2019
#
if [ "${1}xx" == "--help" ]; then
   echo "pin_align.sh image_0 image_90 image_out [tilt_limit]" 
   echo "        compare 0 and 90 degree images"
   echo "        writing the resulting image to image_out"
   echo "        assuming a 1280x1024 images imgagemagick convert"
   echo "        assuming a center at 515 460"
   echo "        assuming 375x400+375+312 ROI"
   echo "        and $PIN_ALIGN_ROOT containing pin_align_prep.sh, etc"
   echo "        tilt_limit is a limit on the image height in pixels"
   echo "        default 50 "
   exit
fi 
roi_width=$(( 375 ))
roi_height=$(( 400 ))
roi_width_offset=$(( 375 ))
roi_height_offset=$(( 312 ))
image_center_width=$(( 515 - $roi_width_offset ))
image_center_height=$(( 460 - $roi_height_offset ))
image_center_width=$(( 515 - $roi_width_offset ))
image_center_height=$(( 460 - $roi_height_offset ))
if [ "${4}xx" == "xx" ]; then
  tilt_limit=60
else
  tilt_limit=$4
fi
tmp_dir=/tmp/${USER}_pin_align_$$ 
mkdir $tmp_dir
echo Processing pin images
echo "0 degree: " $1
echo "90 degrees; " $2
echo "Files in: " $tmp_dir
$PIN_ALIGN_ROOT/pin_align_prep.sh $1 ${tmp_dir}/${1:t:r}_1.jpg > ${tmp_dir}/${1:t:r}_1.mvg 
$PIN_ALIGN_ROOT/pin_align_prep.sh $2 ${tmp_dir}/${1:t:r}_2.jpg > ${tmp_dir}/${1:t:r}_2.mvg 
compare ${tmp_dir}/${1:t:r}_1.jpg ${tmp_dir}/${1:t:r}_2.jpg $3 
diff -bu ${tmp_dir}/${1:t:r}_1.mvg ${tmp_dir}/${1:t:r}_2.mvg > ${tmp_dir}/${3}.mvgdiff
convert  ${tmp_dir}/${1:t:r}_1.jpg -trim info:- > ${tmp_dir}/info_image_1
convert  ${tmp_dir}/${1:t:r}_2.jpg -trim info:- > ${tmp_dir}/info_image_2 
convert $3 -trim info:- > ${tmp_dir}/info_image_compare_1_2
$PIN_ALIGN_ROOT/pin_align_split_info.sh ${tmp_dir}/info_image_1 > ${tmp_dir}/info_image_1.vars
. ${tmp_dir}/info_image_1.vars
#echo info_active_image_height=$info_active_image_height
image_half_height_y=$(( $info_active_image_height / 2 ))
#echo image_half_height_y=$image_half_height_y
image_pin_y=$(( $info_raw_image_height_offset + $image_half_height_y ))
image_pin_y_offset_to_cent=$(( $image_center_height - $image_pin_y  ))
image_pin_y_offset_to_cent=$(( $image_pin_y_offset_to_cent * 5 ))
image_pin_y_offset_to_cent=`echo "scale=2; $image_pin_y_offset_to_cent / 100"|bc -l`
$PIN_ALIGN_ROOT/pin_align_split_info.sh ${tmp_dir}/info_image_2 > ${tmp_dir}/info_image_2.vars
. ${tmp_dir}/info_image_2.vars
image_half_height_z=$(( $info_active_image_height / 2 ))
image_pin_z=$(( $info_raw_image_height_offset + $image_half_height_z ))
image_pin_z_offset_to_cent=$(( $image_center_height - $image_pin_z  ))
image_pin_z_offset_to_cent=$(( $image_pin_z_offset_to_cent * 5 ))
image_pin_z_offset_to_cent=`echo "scale=2; $image_pin_z_offset_to_cent / 100"|bc -l`
$PIN_ALIGN_ROOT/pin_align_split_info.sh ${tmp_dir}/info_image_compare_1_2 > ${tmp_dir}/info_image_compare_1_2.vars
. ${tmp_dir}/info_image_compare_1_2.vars
image_pin_x=$(( $image_center_width - $info_raw_image_width_offset ))
image_pin_x_offset_to_cent=$(( $image_pin_x * 5))
image_pin_x_offset_to_cent=`echo "scale=2; $image_pin_x_offset_to_cent / 100"| bc -l`
 
if [ "$info_raw_image_width_offset" == -1 ]; then
   echo "NO PIN FOUND"
   exit
fi
if [ "$info_raw_image_height_offset" == -1 ]; then
   echo "NO PIN FOUND"
   exit
fi

echo "$info_active_image_height > $tilt_limit"

if (( $(echo "$info_active_image_height > $tilt_limit" | bc -l) )); then
   echo "TILTED; CANNOT CENTER"
fi

echo "X,Y,Z OFFSETS TO CENTER " ${image_pin_x_offset_to_cent},${image_pin_y_offset_to_cent},${image_pin_z_offset_to_cent} 


#cat ${tmp_dir}/info*


