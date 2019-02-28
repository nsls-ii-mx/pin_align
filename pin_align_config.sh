#/bin/bash

#
#  pin_align_config.sh -- configurable pin_align settings to be
#  incoroprated in the pin_align scripts.  You may edit each of
#  the following settings in this script, or you may override
#  each setting as an enviroment variable.
#
#  PIN_ALIGN_DEBUG may be set to any non-null setting to enable
#  debug mode: keep all the files generated and generating a log 
#  file on stderr containing all the error messages and generating 
#  a center if possible.  Debugging mode off will only keep the 
#  original images taken and only generate a center when there is no
#  tilted or bent pin or cap.
#  


#  *** UNCOMMENT THE FOLLOWING LINE TO ENABLE DEBUG MODE ***
#  export PIN_ALIGN_DEBUG="yes"
############################################################



if [ "xx${PIN_ALIGN_DEBUG}" != "xx" ]; then
   echo "PIN_ALIGN: DEBUG enabled" 1>&2
fi

# PIN_ALIGN_TILT_LIMIT gives the number of pixels of pin end-point
# deviation to declare a bent pin

# The following line gives the default value

#  ***  EDIT THE FOLLOWING LINE TO CHANGE THE TILT LIMIT ***
PIN_ALIGN_DEFAULT_TILT_LIMIT="50"
############################################################
 
#  export PIN_ALIGN_TILT_LIMIT=$PIN_ALIGN_DEFAULT_TILT_LIMIT

if [ "xx${PIN_ALIGN_TILT_LIMIT}" == "xx" ]; then
  export PIN_ALIGN_TILT_LIMIT="$PIN_ALIGN_DEFAULT_TILT_LIMIT"
fi

if [ "xx${PIN_ALIGN_DEBUG}" != "xx" ]; then
   echo "PIN_ALIGN_TILT_LIMIT: $PIN_ALIGN_TILT_LIMIT" 1>&2
fi

# PIN_ALIGN_ROI_WIDTH, PIN_ALIGN_ROI_HEIGHT, in pixels, and
# PIN_ALIGN_ROI_WIDTH_OFFSET and PIN_ALIGN_ROI_HEIGHT__OFFSET
# define the region of interest within which the analysis of
# pin alignment is done.  The full image within which the roi
# is defined is implicitly assumed to be 1280x1024, but those
# values are not explicitly used, but the centers 
# PIN_ALIGN_IMAGE_WIDTH_CENTER and PIN_ALIGN_IMAGE_HEIGHT_CENTER
# of the original image in pixels are given

# The following six lines give the default values
# *** EDIT THESE LINES TO CHANGE THESE PARAMETERS
PIN_ALIGN_DEFAULT_ROI_WIDTH=$(( 325 ))
PIN_ALIGN_DEFAULT_ROI_HEIGHT=$(( 400 ))
PIN_ALIGN_DEFAULT_ROI_WIDTH_OFFSET=$(( 375 ))
PIN_ALIGN_DEFAULT_ROI_HEIGHT_OFFSET=$(( 312 ))
PIN_ALIGN_DEFAULT_IMAGE_WIDTH_CENTER=$(( 515 ))
PIN_ALIGN_DEFAULT_IMAGE_HEIGHT_CENTER=$((460 ))
############################################################


if [ "xx${PIN_ALIGN_ROI_WIDTH}" == "xx" ]; then 
  export PIN_ALIGN_ROI_WIDTH="$PIN_ALIGN_DEFAULT_ROI_WIDTH"
fi
if [ "xx${PIN_ALIGN_ROI_HEIGHT}" == "xx" ]; then
  export PIN_ALIGN_ROI_HEIGHT="$PIN_ALIGN_DEFAULT_ROI_HEIGHT"
fi
if [ "xx${PIN_ALIGN_ROI_WIDTH_OFFSET}" == "xx" ]; then
  export PIN_ALIGN_ROI_WIDTH_OFFSET=$PIN_ALIGN_DEFAULT_ROI_WIDTH_OFFSET
fi
if [ "xx${PIN_ALIGN_ROI_HEIGHT_OFFSET}" == "xx" ]; then
  export PIN_ALIGN_ROI_HEIGHT_OFFSET=$PIN_ALIGN_DEFAULT_ROI_HEIGHT_OFFSET
fi
if [ "xx${PIN_ALIGN_IMAGE_WIDTH_CENTER}" == "xx" ]; then
  export PIN_ALIGN_IMAGE_WIDTH_CENTER=$PIN_ALIGN_DEFAULT_IMAGE_WIDTH_CENTER
fi
if [ "xx${PIN_ALIGN_IMAGE_HEIGHT_CENTER}"  == "xx" ]; then
  export PIN_ALIGN_IMAGE_HEIGHT_CENTER=$PIN_ALIGN_DEFAULT_IMAGE_HEIGHT_CENTER
fi

if [ "xx${PIN_ALIGN_DEBUG}" != "xx" ]; then
  if [ "xx${PIN_ALIGN_ROI_WIDTH}" != "xx" ]; then
    echo "PIN_ALIGN_ROI_WIDTH: $PIN_ALIGN_ROI_WIDTH" 1>&2
  fi
  if [ "xx${PIN_ALIGN_ROI_HEIGHT}" != "xx" ]; then
    echo "PIN_ALIGN_ROI_HEIGHT: $PIN_ALIGN_ROI_HEIGHT" 1>&2
  fi
  if [ "xx${PIN_ALIGN_ROI_WIDTH_OFFSET}" != "xx" ]; then
    echo "PIN_ALIGN_ROI_WIDTH_OFFSET: $PIN_ALIGN_ROI_WIDTH_OFFSET" 1>&2
  fi
  if [ "xx${PIN_ALIGN_ROI_HEIGHT_OFFSET}" == "xx" ]; then
    echo "PIN_ALIGN_ROI_HEIGHT_OFFSET: $PIN_ALIGN_ROI_HEIGHT_OFFSET" 1>&2
  fi
  if [ "xx${PIN_ALIGN_IMAGE_WIDTH_CENTER}" == "xx" ]; then
    echo "PIN_ALIGN_IMAGE_WIDTH_CENTER: $PIN_ALIGN_IMAGE_WIDTH_CENTER" 1>&2
  fi
  if [ "xx${PIN_ALIGN_IMAGE_HEIGHT_CENTER}"  == "xx" ]; then
    echo "PIN_ALIGN_IMAGE_HEIGHT_CENTER: $PIN_ALIGN_IMAGE_HEIGHT_CENTER" 1>&2
  fi
fi

# PIN_ALIGN_Y_UP may be set to any non-null setting to change to
# direction of the Y motor axis from down to up
#

#  *** UNCOMMENT THE FOLLOWING LINE TO SET PIN_ALIGN_Y_UP ***
# export PIN_ALIGN_Y_UP=1;   #Y motor axis is up"
############################################################

if [ "xx${PIN_ALIGN_DEBUG}" != "xx" ]; then
   if [ "xx${PIN_ALIGN_Y_UP}" != "xx" ]; then
     echo "PIN_ALIGN: Y motor axis is up" 1>&2
   else
     echo "PIN_ALIGN: Y motor axis is down" 1>&2
   fi
fi

# PIN_ALIGN_Z_UP may be set to any non-null setting to change to
# direction of the Z motor axis from down to up
#

#  *** UNCOMMENT THE FOLLOWING LINE TO SET PIN_ALIGN_Z_UP ***
# export PIN_ALIGN_Z_UP=1;   #Z motor axis is up"
############################################################

if [ "xx${PIN_ALIGN_DEBUG}" != "xx" ]; then
   if [ "xx${PIN_ALIGN_Z_UP}" != "xx" ]; then
     echo "PIN_ALIGN: Z motor axis is up" 1>&2
   else
     echo "PIN_ALIGN: Z motor axis is down" 1>&2
   fi
fi

