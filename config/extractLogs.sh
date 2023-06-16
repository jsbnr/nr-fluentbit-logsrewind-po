#!/bin/bash

# Helper script to configure and run fluent bit to extract files by provided time window.

Help()
{
   # Display Help
   echo "Extract logs by date"
   echo
   echo "options:"
   echo "s    Start time (e.g. '2023/06/16 13:32')"
   echo "e    End time"
   echo "S    Source logs (e.g. '~/logrewind/cache/debug_cache.log') "
   echo "T    Target output file path and prefix (e.g. '~/logrewind/extracted/extracted') "
   echo
}


# Get the options
while getopts ":hs:e:S:T:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      s) # Enter a name
         START=$OPTARG;;
      e) # Enter a name
         END=$OPTARG;;
      S) # Enter a name
         SOURCE_PATH=$OPTARG;;
      T) # Enter a name
         TARGET_PATH=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

START_YEAR=`date -d "${START}" +%Y`
START_MONTH=`date -d "${START}" +%m`
START_DAY=`date -d "${START}" +%d`
START_HOUR=`date -d "${START}" +%H`
START_MINUTE=`date -d "${START}" +%M`

END_YEAR=`date -d "${END}" +%Y`
END_MONTH=`date -d "${END}" +%m`
END_DAY=`date -d "${END}" +%d`
END_HOUR=`date -d "${END}" +%H`
END_MINUTE=`date -d "${END}" +%M`


FILENAME="_${START_YEAR}-${START_MONTH}-${START_DAY}_${START_HOUR}${START_MINUTE}_to_${END_YEAR}-${END_MONTH}-${END_DAY}_${END_HOUR}${END_MINUTE}"
SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

TARGET_FILENAME="${TARGET_PATH}${FILENAME}.log" LOGSOURCE=$SOURCE_PATH envsubst < $SCRIPTPATH/templates/timeBasedRecordExtractor.conf.template > $SCRIPTPATH/timeBasedRecordExtractor.conf


START_YEAR=${START_YEAR} \
START_MONTH=${START_MONTH} \
START_DAY=${START_DAY} \
START_HOUR=${START_HOUR} \
START_MINUTE=${START_MINUTE} \
END_YEAR=${END_YEAR} \
END_MONTH=${END_MONTH} \
END_DAY=${END_DAY} \
END_HOUR=${END_HOUR} \
END_MINUTE=${END_MINUTE} \
 envsubst < $SCRIPTPATH/templates/script.lua.template > $SCRIPTPATH/script.lua

/opt/fluent-bit/bin/fluent-bit -v  --config $SCRIPTPATH/timeBasedRecordExtractor.conf --parser=$SCRIPTPATH/parsers.conf
