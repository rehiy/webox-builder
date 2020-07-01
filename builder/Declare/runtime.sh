#!/bin/bash
#

export wbase=`pwd`
export whome=$wbase/webox

if ! echo $PATH | grep -q $whome; then
    export PATH=$whome/bin:$whome/sbin:$PATH
fi

export osvar=$([ `uname` = "Darwin" ] && echo macos || echo linux)

##############################################HELPERS################

source $wbase/Declare/helper/global
source $wbase/Declare/helper/homebrew
source $wbase/Declare/helper/os_$osvar

source $wbase/Declare/helper/make_package
source $wbase/Declare/helper/make_profile

env_initialize() {

    deps_install

    homebrew_init
    taps_register

    chmod +x $wbase/Formula/*.sh

}
