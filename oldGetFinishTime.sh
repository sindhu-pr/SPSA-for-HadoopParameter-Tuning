if [ $# -ne 1 ];
then
	echo "Please enter a Application ID"
	exit
fi
job=$1

wget -q --output-document=sk --no-proxy http://node1:50030/jobdetails.jsp?jobid=$job&refresh=0
wait
sed -e 's/<[^>]*>//g' sk > nsk
wait
jobName=$(cat nsk|grep "Job Name"| awk '{print $3}')
cat nsk|grep "Finished in" > nnsk
wait

status=$(cat nsk | grep "Status" | sed 's/Status: //g')
wait


if [ "$status" = "Succeeded" ]
then
        spaces=$(grep -o " " < nnsk |wc -l)
        if [ $spaces -eq 5  ]
        then
                #echo "We have days"
                day=$(awk '{print $3}' nnsk|sed 's/[^0-9]//g')
                hour=$(awk '{print $4}' nnsk|sed 's/[^0-9]//g')
                min=$(awk '{print $5}' nnsk|sed 's/[^0-9]//g')
                sec=$(awk '{print $6}' nnsk|sed 's/[^0-9]//g')
                total=$((day*24*60*60+hour*60*60+min*60+sec))
        else
                if [ $spaces -eq 4  ]
                then
                #echo "We have hours"
                        hour=$(awk '{print $3}' nnsk|sed 's/[^0-9]//g')
                        min=$(awk '{print $4}' nnsk|sed 's/[^0-9]//g')
                        sec=$(awk '{print $5}' nnsk|sed 's/[^0-9]//g')
                        total=$((hour*60*60+min*60+sec))
                else
                        if [ $spaces -eq 3  ]
                        then
                                #echo "We have mins"
                                min=$(awk '{print $3}' nnsk|sed 's/[^0-9]//g')
                                sec=$(awk '{print $4}' nnsk|sed 's/[^0-9]//g')
                                total=$((min*60+sec))
                        else
                                #echo "We have secs"
                                sec=$(awk '{print $3}' nnsk|sed 's/[^0-9]//g')
                                total=$sec
                        fi
                fi
        fi
        wait
        #echo "Finish time for $job is $total"
	echo $total $jobName

else
        #echo "0"
        echo $(($(sed -n '1p' < ./init_setting))) $jobName
fi
rm sk nsk nnsk
exit


