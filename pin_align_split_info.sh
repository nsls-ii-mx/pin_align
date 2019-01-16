#!/bin/bash
# pin_align_split_info
# convert an ImgMagick info string in $1 to a set of variable
# assignments in stdout
#     info_file_name=
#     info_file_type=
#     info_active_image_width=
#     info_active_image_height=
#     info_raw_image_width_offset=
#     info_raw_image_height_offset=
#echo $1
if [ -e "$1" ]; then
  info=`cat $1`
else
  info=$1;
fi
IFS=' '; read -r -a info_array <<< "$info"
#echo "${info_array[0]}" "${info_array[1]}" "${info_array[2]}" "${info_array[3]}" "${info_array[4]}" "${info_array[5]}"
echo info_file_name="${info_array[0]}"
echo info_file_type="${info_array[1]}"
IFS="0123456789"; read -r -a active_sep <<< "${info_array[2]}"; 
IFS=' '; read -r -a active_sep_sep <<< "${active_sep[@]}"; #echo raw_sep_sep="${raw_sep_sep[@]}"
IFS='x+- ';read -r -a active <<< "${info_array[2]}"; #echo active="${active[@]}"
echo info_active_image_width="${active[0]}"
echo info_active_image_height="${active[1]}"
IFS=' 0123456789'; read -r -a raw_sep <<< "${info_array[3]}";
IFS=' '; read -r -a raw_sep_sep <<< "${raw_sep[@]}"; #echo raw_sep_sep="${raw_sep_sep[@]}"
IFS='x+- '; read -r -a raw <<< "${info_array[3]}"; #echo "${raw[@]}"
echo info_raw_image_width="${raw[0]}"
echo info_raw_image_height="${raw[1]}"
echo info_raw_image_width_offset="${raw_sep_sep[1]}""${raw[2]}"
echo info_raw_image_height_offset="${raw_sep_sep[2]}""${raw[3]}"
