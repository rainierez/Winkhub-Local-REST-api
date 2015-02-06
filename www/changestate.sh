#! /bin/bash
PATH=$PATH:~/bin

if [ $2 -eq 1 ]; then
  OUTPUT=$(aprontest -u -m$1 -t1 -v ON)
elif [ $2 -eq 0 ]; then
  OUTPUT=$(aprontest -u -m1 -t1 -v OFF)
else
  OUTPUT="Error, incorrect status var. Use 1 for on and 0 for off."
fi

printf '"State":"%s"' "$OUTPUT"
