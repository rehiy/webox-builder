#!/bin/bash
#

export wbase=`pwd`
export whome=$wbase/webox

if ! echo $PATH | grep -q $whome; then
    export PATH=$whome/bin:$whome/sbin:$PATH
fi

export osvar=$([ `uname` = "Darwin" ] && echo macos || echo linux)

##############################################INCLUDE################

source $wbase/Declare/perform/global
source $wbase/Declare/perform/homebrew
source $wbase/Declare/perform/os_$osvar

source $wbase/Declare/perform/make_package
source $wbase/Declare/perform/make_profile

env_initialize() {

    deps_install

    homebrew_init
    taps_register

    chmod +x $wbase/Formula/*.sh

}
