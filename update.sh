#!/bin/bash

chmod +x ./apt-ftparchive
rm Packages*
./apt-ftparchive packages ./debs > Packages
# dpkg-scanpackages -m ./debs > Packages
gzip -c9 Packages > Packages.gz
xz -c9 Packages > Packages.xz
zstd -c19 Packages > Packages.zst
bzip2 -c9 Packages > Packages.bz2

