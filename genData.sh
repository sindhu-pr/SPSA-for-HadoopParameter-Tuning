if [ $# -ne 3 ];
then
echo "Enter Amount of Data to be generated in GB and Path where to store it on HDFS and then locally"
else
data=$(echo "$1 * 10000000"|bc)
hadoop fs -rmr $2
hadoop jar $HADOOP_HOME/hadoop-0.20.2-examples.jar teragen $data $2
wait
echo "Copying to Local"
hadoop fs -copyToLocal $2 $3
wait
hadoop fs -rmr $2
wait
fi


