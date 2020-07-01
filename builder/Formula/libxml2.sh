#!/bin/bash
#

if [ ! -e $whome/cell/libxml2 ]; then
    brew install -v libxml2
fi

if [ ! -e $whome/include/libxml ]; then
    ln -s libxml2/libxml $whome/include/libxml
fi
