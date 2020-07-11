#!/bin/bash
#

cell_install_imagick() {

    if [ ! -d $webox/cell/imagemagick@6 ]; then
        brew install -v imagemagick@6
        if_exit $?
    fi

    if [ ! -e $webox/lib/ImageMagick ]; then
        brew link --force imagemagick@6
    fi

}
