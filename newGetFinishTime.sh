if [ $# -ne 1 ];
then
	echo "Please enter a Application ID"
	exit
fi
firStr=$1
secStr="application_"

appId="${firStr/job_/$secStr}"
#echo $appId
wget -q --output-document=sk --no-proxy http://node1:8088/proxy/$appId/
wait
sed -e 's/<[^>]*>//g' sk > nsk
sed '/^\s*$/d' nsk > bsk
grep -A1 Elapsed bsk|tail -n 1 > ensk
grep -A1 State bsk|tail -n 1 > snsk
cat ensk | tr -d " " > et
cat snsk | tr -d " " > st

status=$(cat st)
#echo "Status is: $status"
wait


if [ "$status" = "SUCCEEDED" ]
then
	#echo "Calculating Time"
        spaces=$(grep -o "," < et |wc -l)
        if [ $spaces -eq 3  ]
        then
                #echo "We have days"
                day=$(awk '{print $1}' et|sed 's/[^0-9]//g')
                hour=$(awk '{print $2}' et|sed 's/[^0-9]//g')
                min=$(awk '{print $3}' et|sed 's/[^0-9]//g')
                sec=$(awk '{print $4}' et|sed 's/[^0-9]//g')
                total=$((day*24*60*60+hour*60*60+min*60+sec))
        else
                if [ $spaces -eq 2  ]
                then
                #echo "We have hours"
                        hour=$(awk '{print $1}' et|sed 's/[^0-9]//g')
                        min=$(awk '{print $2}' et|sed 's/[^0-9]//g')
                        sec=$(awk '{print $3}' et|sed 's/[^0-9]//g')
                        total=$((hour*60*60+min*60+sec))
                else
                        if [ $spaces -eq 1  ]
                        then
                  #              echo "We have mins"
                                min=$(awk -F ',' '{print $1}' et|sed 's/[^0-9]//g')
                                sec=$(awk -F ',' '{print $2}' et|sed 's/[^0-9]//g')
                                total=$((min*60+sec))
                        else
                   #             echo "We have secs"
                                sec=$(awk '{print $1}' et|sed 's/[^0-9]//g')
                                total=$sec
                        fi
                fi
        fi
        wait
	echo $total

else
#        echo "something failed"
        echo $(($(sed -n '1p' < ./init_setting)))
fi
rm -f sk nsk bsk ensk snsk et st
exit


