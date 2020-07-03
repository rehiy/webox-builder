#!/bin/bash
#

brew_install_imagick() {

    if [ ! -d $webox/cell/imagemagick@6 ]; then
        brew install -v imagemagick@6
        if_exit $?
    fi

    brew link --force imagemagick@6

}
