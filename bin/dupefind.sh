#!/bin/bash

if [ -e dupefind.md5.txt ]; then
    rm dupefind.md5.txt
fi
find . -type f -exec md5 -r {} >>dupefind.md5.txt \;
cat dupefind.md5.txt |cut -f1 -d\ |sort |uniq -d >dupes.txt
fgrep -f dupes.txt dupefind.md5.txt |sort 
