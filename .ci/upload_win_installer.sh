#!/bin/bash

dest="ftp://shelter.mahoro-net.org/aegisub-japan7"
tag=$(git describe --exact-match)
[ "$tag" ] || exit

curl -T 'packages\win_installer\output\Aegisub-Japan7-x64.exe' --user $FTP_USER:$FTP_PASS "$dest/Aegisub-Japan7-${tag#v}-x64.exe"
printf "${tag#v}\n$(git tag -l --format='%(contents)' $tag)" > latest
curl -T latest --user "$FTP_USER:$FTP_PASS" "$dest/"
