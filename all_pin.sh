#!/bin/sh
full_path="$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")"
#echo full_path=\"$full_path\"
export PIN_ALIGN_ROOT=`dirname "$full_path" | sed 's/\/bin$//'`
#echo PIN_ALIGN_ROOT=\"$PIN_ALIGN_ROOT\"

$PIN_ALIGN_ROOT/pin_align.sh mitegenPins_omega_0_centered_001.jpg mitegenPins_omega_90_centered_001.jpg mitegenPins_omega_0_90_centered_001.jpg \
mitegenPins_omega_0_90_centered_001_base.jpg mitegenPins_omega_0_90_centered_001_sub_base.jpg 50
$PIN_ALIGN_ROOT/pin_align.sh omega_0_001.jpg  omega_90_001.jpg omega_0_90_001.jpg omega_0_90_001_base.jpg omega_0_90_001_sub_base.jpg 50 
$PIN_ALIGN_ROOT/pin_align.sh omega_0_002.jpg  omega_90_002.jpg omega_0_90_002.jpg omega_0_90_002_base.jpg omega_0_90_002_sub_base.jpg 50
$PIN_ALIGN_ROOT/pin_align.sh omega_0_003.jpg  omega_90_003.jpg omega_0_90_003.jpg omega_0_90_003_base.jpg omega_0_90_003_sub_base.jpg 50
$PIN_ALIGN_ROOT/pin_align.sh omega_0_004.jpg  omega_90_004.jpg omega_0_90_004.jpg omega_0_90_004_base.jpg omega_0_90_004_sub_base.jpg 50
$PIN_ALIGN_ROOT/pin_align.sh omega_0_005.jpg  omega_90_005.jpg omega_0_90_005.jpg omega_0_90_005_base.jpg omega_0_90_005_sub_base.jpg 50
$PIN_ALIGN_ROOT/pin_align.sh omega_0_006.jpg  omega_90_006.jpg omega_0_90_006.jpg omega_0_90_006_base.jpg omega_0_90_006_sub_base.jpg 50
$PIN_ALIGN_ROOT/pin_align.sh omega_0_007.jpg  omega_90_007.jpg omega_0_90_007.jpg omega_0_90_007_base.jpg omega_0_90_007_sub_base.jpg 50
$PIN_ALIGN_ROOT/pin_align.sh omega_0_008.jpg  omega_90_008.jpg omega_0_90_008.jpg omega_0_90_008_base.jpg omega_0_90_008_sub_base.jpg 50
$PIN_ALIGN_ROOT/pin_align.sh omega_0_009.jpg  omega_90_009.jpg omega_0_90_009.jpg omega_0_90_009_base.jpg omega_0_90_009_sub_base.jpg 50
$PIN_ALIGN_ROOT/pin_align.sh omega_0_010.jpg  omega_90_010.jpg omega_0_90_010.jpg omega_0_90_010_base.jpg omega_0_90_010_sub_base.jpg 50
$PIN_ALIGN_ROOT/pin_align.sh omega_0_011.jpg  omega_90_011.jpg omega_0_90_011.jpg omega_0_90_011_base.jpg omega_0_90_011_sub_base.jpg 50
