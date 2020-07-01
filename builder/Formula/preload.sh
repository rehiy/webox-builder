#!/bin/bash
#

if [ ! -e $whome/lib/gcc ]; then
    brew_install gcc
fi

if [ ! -e $whome/lib/ld.so ]; then
    brew_install glibc
fi

if [ ! -e $whome/lib/libpcre.so ]; then
    brew_install libpcre
fi

if [ ! -e $whome/include/libxml ]; then
    brew_install libxml2
fi
