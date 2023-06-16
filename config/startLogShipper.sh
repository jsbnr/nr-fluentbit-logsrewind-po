#!/bin/bash

# Helper script to configure start the fluentbit log shipper. This is just for demo purposes!

Help()
{
   # Display Help
   echo "Startlog shipper"
   echo
   echo "options:"
   echo "S    Source log path (e.g. '~/logrewind/logs/*.log')"
   echo "C    Cache path (e.g. '~/logrewind/cache/debug_cache.log)"
   echo "E    Time based extracted logs path (e.g. '~/logrewind/extracted/*.log')"
   echo "K    New Relic logs API Key (e.g. 54....NRAL)"
   echo
}


# Get the options
while getopts ":hS:C:E:K:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      S) SOURCE_PATH=$OPTARG;;
      C) CACHE_PATH=$OPTARG;;
      E) EXTRACT_PATH=$OPTARG;;
      K) APIKEY=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

if [[ -z $SOURCE_PATH || -z $CACHE_PATH || -z $EXTRACT_PATH || -z $APIKEY ]]; then
   Help; exit;
else
   SCRIPT=$(realpath "$0")
   SCRIPTPATH=$(dirname "$SCRIPT")

   SOURCE_PATH="${SOURCE_PATH}" \
   CACHE_PATH="${CACHE_PATH}" \
   EXTRACT_PATH="${EXTRACT_PATH}" \
   LOGLEVEL='$LOGLEVEL' \
   APIKEY="${APIKEY}" \
    envsubst < $SCRIPTPATH/templates/generalLogShipper.conf.template > $SCRIPTPATH/generalLogShipper.conf

   /opt/fluent-bit/bin/fluent-bit  --config "$SCRIPTPATH/generalLogShipper.conf" --parser="$SCRIPTPATH/parsers.conf"
fi
