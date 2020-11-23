#!/bin/bash
#

cell_install_gcc() {

    if [ ! -d $webox/cell/gcc@7 ]; then
        brew install -v gcc@7
        if_exit $?
    fi

    if [ ! -e $webox/lib/libgcc_s.so ]; then
        cell_install_gcc_libfix
    fi

}

cell_install_gcc_libfix() {

    cd $webox

    # Fix for system gccs that do not support -static-libstdc++

    for vvv in `find cell/gcc@7/ -name "libstdc++.*"`; do
        ln -sf ../$vvv $webox/lib
    done

    for vvv in `find cell/gcc@7/ -name "libgcc_s.*"`; do
        ln -sf ../$vvv $webox/lib
    done

    # fix for llvm depends

    mkdir -p cell/gcc
    ln -sf ../gcc@7/`ls cell/gcc@7` cell/gcc/5.5.0_7

    # last pwd

    cd -

}
