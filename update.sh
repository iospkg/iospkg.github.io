#!/bin/bash

dpkg-scanpackages -m ./debs > Packages
xz -c9 Packages > Packages.xz
bzip2 -c9 Packages > Packages.bz2
gzip -c Packages > Packages.gz
zstd -q -c19 Packages > Packages.zst

