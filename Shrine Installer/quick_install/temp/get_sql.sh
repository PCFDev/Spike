#!/bin/bash

echo "writing output to" $1

rm -f $1

for file in `find . -name '*.sql' -print`
do

    echo "-- FILENAME: " $file >> $1
    cat $file >> $1
    echo "" >> $1
    echo "" >> $1

done
