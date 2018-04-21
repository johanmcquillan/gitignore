#!/bin/bash

set -e

for ARG in $@
do
    # ARG maybe a code name eg. Python
    #   or a file name      eg. Python.gitignore
    case $ARG in
        *.gitignore) CODE=${ARG%.gitignore} ;;
        *) CODE=$ARG ;;
    esac
    FILE=$CODE.gitignore

    if [ -e $FILE ]
    then
        # Header line to add
        HEADER="### $CODE"
        # Current top line
        FILE_HEADER=$(head -n 1 $FILE)

        # If header already present, do nothing
        if [[ "$HEADER" == "$FILE_HEADER" ]]
        then
            echo "$FILE already in correct format"
        else
            # Add header and gitignore to temporary file
            printf "$HEADER\n\n" > tmp
            cat $FILE >> tmp
            
            # Maintain file permissions
            MODE=$(stat -f %0Lp $FILE)
            chmod $MODE tmp

            mv tmp $FILE
            echo "Converted $FILE"
        fi
    else
        echo "$FILE not found"
    fi
done
