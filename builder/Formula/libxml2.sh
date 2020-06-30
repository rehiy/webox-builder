#!/bin/bash
#

if [ ! -e $whome/include/libxml2 ]; then
    brew install libxml2
fi

if [ ! -e $whome/include/libxml ]; then
    ln -s libxml2/libxml $whome/include/libxml
fi
