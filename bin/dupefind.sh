#!/bin/bash

MD5FILE='dupefind.md5list.txt'

if [ -e MD5FILE ]; then
    rm $MD5FILE
fi
find . -type f -exec md5 -r {} >>$MD5FILE \;
cat $MD5FILE |cut -f1 -d\ |sort |uniq -d >dupes.txt
fgrep -f dupes.txt $MD5FILE |sort | tee dupefind.dupefiles.txt
