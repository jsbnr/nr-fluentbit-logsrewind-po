#!/usr/bin/env bash


# Helper script to generate some test data. This sends log lines with INFO, ERROR or DEBUG

Help()
{
   # Display Help
   echo "Generate random log data"
   echo
   echo "options:"
   echo "P    Filepath to send logs to (e.g. '~/logrewind/logs/generated.log' )"
   echo
}


# Get the options
while getopts ":hP:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      P) OUTPUT=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done



if [[ -z $OUTPUT ]]; then
        Help; exit;
else
        while true
        do

                random_size=$(( (RANDOM % 65535) + 1  ))
                current_date_time=$(date '+%Y/%m/%d %H:%M:%S')
                case $((RANDOM % 100)) in
                        ([0-4]*) LOGLEVEL='INFO'
                                ;;
                        ([5-8]*) LOGLEVEL='DEBUG'
                                ;;
                        (*) LOGLEVEL='ERROR'
                                ;;
                esac

                echo "[$current_date_time] $LOGLEVEL Some random data here ${random_size}" | tee -a $OUTPUT

                sleep 1s
        done
        
fi
