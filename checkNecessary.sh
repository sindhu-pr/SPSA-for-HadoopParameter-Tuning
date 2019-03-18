#Make sure that all the prerequiste are match

if [ -z ${HADOOP_HOME+x} ];
	then echo "HADOOP_HOME is unset";
	exit;
else
	echo "HADOOP_HOME is set to '$HADOOP_HOME'";
fi


nameNode=$(jps|grep -e " NameNode"|wc -l)
one=1;
if [ $nameNode -eq $one ]; then
    echo "NameNode is Running";
else
    echo "Make Sure Hadoop Cluster is running"
    exit
fi

for p in $(cat init_setting|grep /|grep -v "hduser")
do
if [ -e $p ]
then
	echo "Directory $p exists."
else
	echo "Error: Directory $p does not exists."
	exit
fi
done
