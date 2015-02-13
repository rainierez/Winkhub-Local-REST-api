#! /bin/bash
PATH=$PATH:~/bin

function dimmable {
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

  printf '"%s":{"Type": "Dimmable Light","Status": "%s","Level": "%s"' "$1" "$STATUS" "$LEVEL"
}

function onoff {
  if  aprontest -l -m $1 | awk '/On_Off/' | cut -c 100-102 | grep "ON" > /dev/null ;
  then
    STATUS="ON"
  else
    STATUS="OFF"
  fi

  printf '"%s":{"Type": "On/Off","Status": "%s"' "$1" "$STATUS"
}

if [ $1 == "all" ]; then
  printf '{'
  for (( DEVICEID=1; DEVICEID<=${2:-25}; DEVICEID++ ))
  do
    if  aprontest -l -m $DEVICEID | awk '/New HA Dimmable Light/' | grep 'New HA Dimmable Light' > /dev/null;
    then
      if [ $DEVICEID -gt 1 ] ;
      then
        printf '},'
      fi
      dimmable $DEVICEID
    elif aprontest -l -m $DEVICEID | awk '/New On\/Off Output/' | grep 'New On\/Off Output' > /dev/null;
    then
      if [ $DEVICEID -gt 1 ] ;
      then
        printf '},'
      fi
      onoff $DEVICEID
    fi
  done
  printf '}}'

else

  if  aprontest -l -m $1 | awk '/New HA Dimmable Light/' | grep 'New HA Dimmable Light' > /dev/null;
  then
    printf '{'
    dimmable $1
    printf '}}'
  elif aprontest -l -m $1 | awk '/New On\/Off Output/' | grep 'New On\/Off Output' > /dev/null;
  then
    printf '{'
    onoff $1
    printf '}}'
  else
    printf '{"Response":"Not a supported device or no device present"}'
  fi
fi
