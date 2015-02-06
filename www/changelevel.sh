#! /bin/bash
PATH=$PATH:~/bin

OUTPUT=$(aprontest -u -m$1 -t2 -v $2)

printf '"Level":"%s"' "$OUTPUT"
