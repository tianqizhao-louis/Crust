#!/bin/bash

# author: Crystal Ren
set -e

if [ -z "$1" ]
  then
    echo "Usage: ./run.sh <name_of_file.crust>"
    exit 1
fi
f=$1
n=${f%.mc*}
cat $f | ./crust.native > "$n.ll"
llc -relocation-model=pic "$n.ll"
cc -o "$n" "$n.s" "helper_in_c.o" "-lm"
"./$n"
rm $n.ll $n.s
