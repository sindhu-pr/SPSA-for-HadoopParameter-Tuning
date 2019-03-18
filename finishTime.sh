#!/bin/bash

hadoop job -list all |  grep job_ |awk '{print $1}' > jobs
sort -n -r jobs  > sorted_jobs
wait
job=$(head -n 1 sorted_jobs)
echo $job

hadoopVersion=$(hadoop version|head -n 1|awk '{print $2}')

#total=0

if [[ $(hadoop version|head -n 1|awk '{print $2}') = "2.7.3" ]]; then
echo "New Hadoop"
val=$(./newGetFinishTime.sh $job)
else
echo "Old Hadoop"
val=$(./oldGetFinishTime.sh $job)
fi
#total=$(($total + $val))
total=$val
echo $total
echo $total|awk '{print $1}' > finishTime
echo $total|awk '{print $2}' > finishName

finishName=$(cat finishName)

if [[ $finishName = "grep-sort" ]];then
echo "Look Again"
job=$(head -n 2 sorted_jobs|tail -n 1)
echo "New Job Id: "$job
if [[ $(hadoop version|head -n 1|awk '{print $2}') = "2.7.3" ]]; then
echo "New Hadoop"
val=$(./newGetFinishTime.sh $job)
else
echo "Old Hadoop"
val=$(./oldGetFinishTime.sh $job)
fi
#total=$(($total + $val))
total=$val
echo $total
echo $total|awk '{print $1}' > finishTime
echo $total|awk '{print $2}' > finishName

else
echo "its ok"
fi





