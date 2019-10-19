#!/bin/sh -e

export MAKEFLAGS="-j$(nproc)"
cd /aegisub
dpkg-buildpackage -nc

mv ../*.deb /out/
