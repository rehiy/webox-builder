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

    for vvv in `find cell/gcc@7/ -name "*.so.*"`; do
        ln -sf ../$vvv $webox/lib
    done

    cd -

}
