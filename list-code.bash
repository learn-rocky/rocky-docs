#!/bin/sh
#Note that '│' is a unicode box drawing character
trans -R |
    sed 's/ Sund/│Sund/g;s/ *//g' |
    awk -F '│' '{print $2"\n"$3"\n"$4}' |
    sort -u |
        tail -n+2
