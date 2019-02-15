#!/bin/bash
#
#  pin_align.sh -- ccmparison 0 and 90 degree images
#                       H. J. Bernstein, 3 Jan 2019
#
full_path="$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")"
#echo full_path=\"$full_path\"
if [ -d /usr/local/bin/topViewCam ]; then
   export PIN_ALIGN_ROOT=/usr/local/bin/topViewCam
fi
#echo PIN_ALIGN_ROOT=\"$PIN_ALIGN_ROOT\"

#echo 0 $0 
#echo 1 $1 
#echo 2 $2 
#echo 3 $3 
#echo 4 $4 
#echo 5 $5 

if [ "${1}xx" == "--helpxx" ]; then
   echo "pin_align.sh image_0 image_90 image_out image_base_out image_sub_base_out [tilt_limit]" 
   echo "        compare 0 and 90 degree images"
   echo "        writing the resulting pin tip image to image_out"
   echo "        writing the resulting pin base image to image_base_out"
   echo "        writing the resulting pin base cap image to image_sub_base_out"
   echo "        assuming  1280x1024 images"
   echo "        imagemagick convert called as convert"
   echo "        imagemagick compare called as conpare"
   echo "        assuming a center at 515 460"
   echo "        assuming 325x400+375+312 ROI"
   echo "        and $PIN_ALIGN_ROOT containing pin_align_prep.sh, etc"
   echo "        tilt_limit is a limit on the image height in pixels"
   echo "        default 50 "
   echo " "
   echo "        export PIN_ALIGN_Y_UP=1; if Y motor axis is up"
   echo "        export PIN_ALIGN_Z_UP=1; if Z motor axis is up"
   echo " "
   exit
fi

fuzz="9% -threshold 50%"
fname=$1
fname=${fname##*/}
fbase=${fname%%.*} 
 
roi_width=$(( 325 ))
roi_height=$(( 400 ))
roi_width_offset=$(( 375 ))
roi_height_offset=$(( 312 ))
image_center_width=$(( 515 - $roi_width_offset ))
image_center_height=$(( 460 - $roi_height_offset ))
if [ "${6}xx" == "xx" ]; then
  tilt_limit=50
else
  tilt_limit=$6
fi
base_tilt_limit=$(( $tilt_limit * 4  ))
base_tilt_limit=$(( $base_tilt_limit / 3  ))
sub_base_tilt_limit=$(( $tilt_limit / 3 ))
tmp_dir=$PWD/${USER}_pin_align_$$ 
mkdir $tmp_dir
echo Processing pin images
echo "0 degree: " $1
echo "90 degrees; " $2
echo "Files in: " $tmp_dir

#  Assume images have the origin top left, with image_width increasing left to right
#  image_height increasing top to bottom
#  Assume 0 degree image has  motor-x horizontal increasing right to left
#                             i.e. opposite to image_width
#                             motor-z vertical increasing bottom to top
#                             i.e. opposite to image_height 
#  Assume 90 degree image has motor-x horizontal increasing right to left
#                             i.e. opposite to image_width
#                             motor-y vertical increasing top to bottom
#                             i.e. with image_height 
#                             unless environment variable PIN_ALIGN_Y_UP is not empty

XZ=$1
XY=$2

# Names ending in _1.pgm are 0 degrees and names ending in _2.pgm are 90 degress.
$PIN_ALIGN_ROOT/pin_align_prep.sh $XZ ${tmp_dir}/${fbase}_1.pgm \
${tmp_dir}/${fbase}_1_base.pgm ${tmp_dir}/${fbase}_1_sub_base.pgm> ${tmp_dir}/${fbase}_1.mvg 
echo $PIN_ALIGN_ROOT
$PIN_ALIGN_ROOT/pin_align_prep.sh $XY ${tmp_dir}/${fbase}_2.pgm \
${tmp_dir}/${fbase}_2_base.pgm ${tmp_dir}/${fbase}_2_sub_base.pgm> ${tmp_dir}/${fbase}_2.mvg 
compare ${tmp_dir}/${fbase}_1.pgm ${tmp_dir}/${fbase}_2.pgm $3 
compare ${tmp_dir}/${fbase}_1_base.pgm ${tmp_dir}/${fbase}_2_base.pgm $4 
compare ${tmp_dir}/${fbase}_1_sub_base.pgm ${tmp_dir}/${fbase}_2_sub_base.pgm $5 
diff -bu ${tmp_dir}/${fbase}_1.mvg ${tmp_dir}/${fbase}_2.mvg > ${tmp_dir}/${3}.mvgdiff

########### Original ##############
#convert  ${tmp_dir}/${fbase}_1.pgm -trim info:- > ${tmp_dir}/info_image_1
#convert  ${tmp_dir}/${fbase}_2.pgm -trim info:- > ${tmp_dir}/info_image_2 
#convert $3 -trim info:- > ${tmp_dir}/info_image_compare_1_2
#convert $4 -trim info:- > ${tmp_dir}/info_image_compare_1_2_base
#convert $5 -trim info:- > ${tmp_dir}/info_image_compare_1_2_sub_base

########## fuzz factor #############
convert  ${tmp_dir}/${fbase}_1.pgm -fuzz $fuzz -trim info:- > ${tmp_dir}/info_image_1
convert  ${tmp_dir}/${fbase}_2.pgm -fuzz $fuzz -trim info:- > ${tmp_dir}/info_image_2 
convert $3 -fuzz $fuzz -trim info:- > ${tmp_dir}/info_image_compare_1_2
convert $4 -fuzz $fuzz -trim info:- > ${tmp_dir}/info_image_compare_1_2_base
convert $5 -fuzz $fuzz -trim info:- > ${tmp_dir}/info_image_compare_1_2_sub_base

$PIN_ALIGN_ROOT/pin_align_split_info.sh ${tmp_dir}/info_image_1 > ${tmp_dir}/info_image_1.vars
. ${tmp_dir}/info_image_1.vars
#echo "${tmp_dir}/info_image_1.vars:"
#cat ${tmp_dir}/info_image_1.vars
image_half_height_z=$(( $info_active_image_height / 2 ))
image_pin_x1_orig=$(( $info_raw_image_width_offset + $roi_width_offset ))
image_pin_x1_offset_to_cent=$(( $image_center_width - $info_raw_image_width_offset ))
image_pin_x1_offset_to_cent=$(( $image_pin_x1_offset_to_cent * 5 ))
image_pin_x1_offset_to_cent=`echo "scale=2; -1* $image_pin_x1_offset_to_cent / 100"| bc -l`
x1_clip=$(( ${info_raw_image_width_offset} + 375 ))
#echo ${x1_clip}
image_pin_z=$(( $info_raw_image_height_offset + $image_half_height_z ))
image_pin_z_orig=$(( $image_pin_z + $roi_height_offset ))
image_pin_z_offset_to_cent=$(( $image_center_height - $image_pin_z  ))
image_pin_z_offset_to_cent=$(( $image_pin_z_offset_to_cent * 5 ))
if [ "xx${PIN_ALIGN_Z_UP}" != "xx" ]; then  
    image_pin_z_offset_to_cent=`echo "scale=2; $image_pin_z_offset_to_cent / 100"|bc -l`
else
    image_pin_z_offset_to_cent=`echo "scale=2; -1* $image_pin_z_offset_to_cent / 100"|bc -l`
fi
################### original #################
#convert $1 -crop "10x400+${x1_clip}+312" -contrast -contrast -canny 2x1 -negate -colorspace Gray -morphology Erode Octagon:1 -morphology Dilate Octagon:1 ${tmp_dir}/${fbase}_1_left.pgm
#convert ${tmp_dir}/${fbase}_1_left.pgm -trim info:- > ${tmp_dir}/${fbase}_1_left.pgm.info

################### fuzz factor #################  
convert $1 -crop "10x400+${x1_clip}+312" -contrast -contrast -canny 2x1 -negate -colorspace Gray -morphology Erode Octagon:1 -morphology Dilate Octagon:1 ${tmp_dir}/${fbase}_1_left.pgm
convert ${tmp_dir}/${fbase}_1_left.pgm -fuzz $fuzz -trim info:- > ${tmp_dir}/${fbase}_1_left.pgm.info

$PIN_ALIGN_ROOT/pin_align_split_info.sh ${tmp_dir}/${fbase}_1_left.pgm.info > ${tmp_dir}/info_image_1_left.vars
. ${tmp_dir}/info_image_1_left.vars
#echo "${tmp_dir}/info_image_1_left.vars:"
#cat ${tmp_dir}/info_image_1_left.vars

image_half_height_z2=$(( $info_active_image_height / 2 ))
image_pin_z2=$(( $info_raw_image_height_offset + $image_half_height_z2 ))
image_pin_z2_orig=$(( $image_pin_z2 + $roi_height_offset ))
image_pin_z2_offset_to_cent=$(( $image_center_height - $image_pin_z2  ))
image_pin_z2_offset_to_cent=$(( $image_pin_z2_offset_to_cent * 5 ))
if [ "xx${PIN_ALIGN_Z_UP}" != "xx" ]; then  
    image_pin_z2_offset_to_cent=`echo "scale=2; $image_pin_z2_offset_to_cent / 100"|bc -l`
else
    image_pin_z2_offset_to_cent=`echo "scale=2; -1*  $image_pin_z2_offset_to_cent / 100"|bc -l`
fi

$PIN_ALIGN_ROOT/pin_align_split_info.sh ${tmp_dir}/info_image_2 > ${tmp_dir}/info_image_2.vars
. ${tmp_dir}/info_image_2.vars
#echo "${tmp_dir}/info_image_2.vars:"
#cat ${tmp_dir}/info_image_2.vars
image_half_height_y=$(( $info_active_image_height / 2 ))
image_pin_x2_orig=$(( $info_raw_image_width_offset + $roi_width_offset ))
image_pin_x2_offset_to_cent=$(( $image_center_width - $info_raw_image_width_offset ))
image_pin_x2_offset_to_cent=$(( $image_pin_x2_offset_to_cent * 5 ))
image_pin_x2_offset_to_cent=`echo "scale=2; -1* $image_pin_x2_offset_to_cent / 100"| bc -l`
x2_clip=$(( ${info_raw_image_width_offset} + 375 ))
#echo $x2_clip
image_pin_y=$(( $info_raw_image_height_offset + $image_half_height_y ))
image_pin_y_orig=$(( $image_pin_y + $roi_height_offset ))
image_pin_y_offset_to_cent=$(( $image_center_height - $image_pin_y  ))
image_pin_y_offset_to_cent=$(( $image_pin_y_offset_to_cent * 5 ))
if [ "xx${PIN_ALIGN_Y_UP}" != "xx" ]; then  
    image_pin_y_offset_to_cent=`echo "scale=2; $image_pin_y_offset_to_cent / 100"|bc -l`
else
    image_pin_y_offset_to_cent=`echo "scale=2; - $image_pin_y_offset_to_cent / 100"|bc -l`
fi
################################ original #######################
#convert $2 -crop "10x400+${x2_clip}+312"  -contrast -contrast -canny 2x1 -negate -colorspace Gray -morphology Erode Octagon:1 -morphology Dilate Octagon:1 ${tmp_dir}/${fbase}_2_left.pgm
#convert ${tmp_dir}/${fbase}_2_left.pgm  -trim info:- > ${tmp_dir}/${fbase}_2_left.pgm.info

########################### fuzz factor ########################
convert $2 -crop "10x400+${x2_clip}+312"  -contrast -contrast -canny 2x1 -negate -colorspace Gray -morphology Erode Octagon:1 -morphology Dilate Octagon:1 ${tmp_dir}/${fbase}_2_left.pgm
convert ${tmp_dir}/${fbase}_2_left.pgm -fuzz $fuzz -trim info:- > ${tmp_dir}/${fbase}_2_left.pgm.info


$PIN_ALIGN_ROOT/pin_align_split_info.sh ${tmp_dir}/${fbase}_2_left.pgm.info > ${tmp_dir}/info_image_2_left.vars
. ${tmp_dir}/info_image_2_left.vars
#echo "${tmp_dir}/info_image_2_left.vars:"
#cat ${tmp_dir}/info_image_2_left.vars

image_half_height_y2=$(( $info_active_image_height / 2 ))
image_pin_y2=$(( $info_raw_image_height_offset + $image_half_height_y2 ))
image_pin_y2_orig=$(( $image_pin_y2 + $roi_height_offset ))
image_pin_y2_offset_to_cent=$(( $image_center_height - $image_pin_y2  ))
image_pin_y2_offset_to_cent=$(( $image_pin_y2_offset_to_cent * 5 ))
if [ "xx${PIN_ALIGN_Y_UP}" != "xx" ]; then  
    image_pin_y2_offset_to_cent=`echo "scale=2; $image_pin_y2_offset_to_cent / 100"|bc -l`
else
    image_pin_y2_offset_to_cent=`echo "scale=2; - $image_pin_y2_offset_to_cent / 100"|bc -l`
fi

$PIN_ALIGN_ROOT/pin_align_split_info.sh ${tmp_dir}/info_image_compare_1_2 > ${tmp_dir}/info_image_compare_1_2.vars
. ${tmp_dir}/info_image_compare_1_2.vars
#cat ${tmp_dir}/info_image_compare_1_2.vars

image_pin_x_orig=$((  $info_raw_image_width_offset + $roi_width_offset  ))
image_pin_x_offset_to_cent=$(( $image_center_width - $info_raw_image_width_offset ))
image_pin_x_offset_to_cent=$(( $image_pin_x_offset_to_cent * 5 ))
image_pin_x_offset_to_cent=`echo "scale=2; -1* $image_pin_x_offset_to_cent / 100"| bc -l`

nooutput=0
 
if [ "$info_raw_image_width_offset" == -1 ]; then
   echo "NO PIN FOUND"
   exit
fi
if [ "$info_raw_image_height_offset" == -1 ]; then
   echo "NO PIN FOUND"
   exit
fi

if (( $(echo "$info_active_image_height > $tilt_limit" | bc -l) )); then
   echo "PIN TILTED; CANNOT CENTER"
   echo "info_active_image_height:${info_active_image_height} > tilt_limit:${tilt_limit}"
   nooutput=1
   exit
fi

$PIN_ALIGN_ROOT/pin_align_split_info.sh ${tmp_dir}/info_image_compare_1_2_base > ${tmp_dir}/info_image_compare_1_2_base.vars
. ${tmp_dir}/info_image_compare_1_2_base.vars

pin_center=$(( $info_active_image_height / 2 ))
pin_center=$(( $info_raw_image_height_offset + $pin_center ))
pin_center=$((  $roi_height_offset + $pin_center ))

if (( $(echo "$info_active_image_height > $base_tilt_limit" | bc -l) )); then
   echo "BASE TILTED; CANNOT CENTER"
   echo "info_active_image_height:${info_active_image_height} .gt. base_tilt_limit:${base_tilt_limit}"
   nooutput=1
fi

$PIN_ALIGN_ROOT/pin_align_split_info.sh ${tmp_dir}/info_image_compare_1_2_sub_base > ${tmp_dir}/info_image_compare_1_2_sub_base.vars
. ${tmp_dir}/info_image_compare_1_2_sub_base.vars

sub_base_center=$(( $info_active_image_height / 2 ))
sub_base_center=$(( $info_raw_image_height_offset + $sub_base_center ))
sub_base_center=$((  $roi_height_offset + $sub_base_center ))


if (( $(echo "$pin_center > $sub_base_center" | bc -l) )); then
   if (( $(echo "$pin_center - $sub_base_center > $sub_base_tilt_limit" | bc -l) )); then
       echo "BASE TILTED; CANNOT CENTER"
       echo "pin_center:${pin_center} - sub_base_center:${sub_base_center}: .gt. sub_base_tilt_limit:${sub_base_tilt_limit}"
       nooutput=1
   fi
else
   if (( $(echo "$sub_base_center - $pin_center  > $sub_base_tilt_limit" | bc -l) )); then
       echo "BASE TILTED; CANNOT CENTER"
       echo "sub_base_center:${sub_base_center} - pin_center:${pin_center}: .gt. sub_base_tilt_limit:${sub_base_tilt_limit}"
       nooutput=1
   fi
fi


if [ "xx${nooutput}" == "xx0" ]; then
    if (( $(echo "${image_pin_x1_orig} < ${image_pin_x2_orig}" | bc -l)  )); then
      image_pin_x_orig=${image_pin_x1_orig}
      image_pin_x_offset_to_cent=${image_pin_x1_offset_to_cent}
    else
      image_pin_x_orig=${image_pin_x2_orig}
      image_pin_x_offset_to_cent=${image_pin_x2_offset_to_cent}
    fi
    echo "OMEGA 0  X,-,Z PIN POS IMAGE2 PX"  [${image_pin_x1_orig}, - , ${image_pin_z2_orig} ]; # adding omega values
    echo "OMEGA 90 X,Y,- PIN POS IMAGE1 PX"  [${image_pin_x2_orig}, ${image_pin_y2_orig}, - ];  # adding omega values
    echo "OVERALL  X,Y,Z PIN POS        PX"  [${image_pin_x_orig}, ${image_pin_y2_orig}, ${image_pin_z2_orig} ]; # move to better align

    echo "OMEGA 0  X,-,Z OFFSETS TO CENTER IMAGE2 mm"   [${image_pin_x1_offset_to_cent}, - , ${image_pin_z2_offset_to_cent} ]
    echo "OMEGA 90 X,Y,- OFFSETS TO CENTER IMAGE1 mm"   [${image_pin_x2_offset_to_cent}, ${image_pin_y2_offset_to_cent}, - ]; # change order to be below XZ plane for better visual
    echo "OVERALL X,Y,Z OFFSETS TO CENTER         mm"   [${image_pin_x_offset_to_cent}, ${image_pin_y2_offset_to_cent}, ${image_pin_z2_offset_to_cent} ]; # move to better align


#cat ${tmp_dir}/info*

fi

