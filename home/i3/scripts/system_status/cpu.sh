#!/usr/bin/env zsh
case "$1" in
    --popup)
        dunstify -i "" -t 3000 -r 9574 -u normal " CPU time (%)" "$(ps axch -o cmd:10,pcpu k -pcpu | head | awk '$0=$0"%"' )"
        ;;
    *)
        # calculate cpu load (percentage)
        cpu_clock=$(lscpu | grep "CPU MHz:" | awk '{print $3}')
        max_clock=$(lscpu | grep "CPU max MHz:" | awk '{print $4}')
        # replace , in max clock with .
        max_clock="${max_clock//[,]/.}"
        # calculate clock percentage of max
        clock_percentage="$(( cpu_clock * 100 / max_clock ))"
        # for print, separate int part and floating point digits
        clock_percentage_int=${clock_percentage%%.*}
        clock_percentage_rat=${clock_percentage##*.}
        # only display 2 floating digits
        clock_percentage="${clock_percentage_int}.${clock_percentage_rat:0:2}"

        # get cpu temperature
        cpu_temp=$(sensors | grep "Package id 0:" | head -1 | awk '{print $4}')
        # remove + and floating point digit
        cpu_temp="${cpu_temp//+}"
        cpu_temp="${cpu_temp//.0}"
        echo " $clock_percentage%    $cpu_temp"
        ;;
esac
