#! /bin/bash
PATH=$PATH:~/bin
printf '{'
function status {
        if  aprontest -l -m $1 | awk '/HA Dimmable Light/'  | cut -c5-21 | grep 'HA Dimmable Light' > /dev/null ;
        then
                if [ $LOOP -eq 1 ] ;
                then
                        if [ $1 -gt 1 ] ;
                        then
                                printf '},'
                        fi
                fi

                if aprontest -l -m $1 | awk '/Level/' | cut -c 100 | grep " " > /dev/null ;
                then
                        LEVEL=$(aprontest -l -m $1 | awk '/Level/' | cut -c 101)
                elif aprontest -l -m $1 | awk '/Level/' | cut -c 99 | grep " " > /dev/null ;
                then
                        LEVEL=$(aprontest -l -m $1 | awk '/Level/' | cut -c 100-101)
                else
                        LEVEL=$(aprontest -l -m $1 | awk '/Level/' | cut -c 99-101)
                fi

                if aprontest -l -m $1 | awk '/On_Off/' | cut -c 95-102 | grep " ON " > /dev/null ;
                then
                        STATUS="ON"
                else
                        STATUS="OFF"
                fi

                printf '"%s":{"Status": "%s","Level": "%s"' "$1" "$STATUS" "$LEVEL"
        fi
}

if [ $1 == "all" ]; then

        for (( DEVICEID=1; DEVICEID<=${2:-25}; DEVICEID++ ))
        do
                LOOP=1
                status $DEVICEID
        done
else
        LOOP=0
        status $1
fi
printf '}}'