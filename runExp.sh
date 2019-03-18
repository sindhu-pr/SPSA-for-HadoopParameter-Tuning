#=========================Make sure that all the prerequiste are match
clear
testMode=1
if [ $testMode -eq 0 ]; then

if [ -z ${HADOOP_PREFIX+x} ];
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

for p in $(cat init_setting|grep /|grep -v "hduser"|grep -v "HADOOP_HOME")
do
if [ -e "$p" ]
then
        echo "Directory $p exists."
else
        echo "Error: Directory $p does not exists."
        exit
fi
done
fi

#==================== CLEAN UP

rm -f grad_data.csv
rm -f grad_data2.csv
rm -f grad_data_par_val.csv

#================ COPY DATA
#inpPathLocal=$(cat init_setting|grep '*')
inpPathHDFS=$(cat init_setting|grep hduser|grep inp)
echo $inpPathHDFS

hadoop fs -test -e $inpPathHDFS

if [ $? -eq 0 ]; then
    echo "Input Data exists"
else
	echo "Input Data Does not Exist. Please copy it Manually"
	exit
#	hadoop fs -mkdir $inpPathHDFS
#	hadoop fs -copyFromLocal $inpPathLocal "$inpPathHDFS"
#	wait
fi

#===========Setup Parameters
echo "Setting up Parameters File"
#config_switch
awk -F "," '{print $1}' par_info |tail -n +2 > config_switch
#par_type
awk -F "," '{print $2}' par_info |tail -n +2 > par_type
#par_def
awk -F "," '{print $3}' par_info |tail -n +2 > par_def
#par_minval
awk -F "," '{print $4}' par_info |tail -n +2 > par_minval
#par_max_val
awk -F "," '{print $5}' par_info |tail -n +2 > par_maxval

#=================== RUN THE CODE


javac -cp ./commons-exec-1.0.jar:. config.java
octave -q sim.m


#========== Save Experiment Details

totlines=$(wc -l grad_data.csv |awk '{print $1}')
if [[ $totlines -lt 6 ]]; then
echo "Experiment is Not Valid. Not Saving"
else
echo "Valid Experiment. Saving to Experiments folder"

hadoopVersion=$(hadoop version|head -n 1|awk '{print $2}')
expDir="Experiments"
if [ ! -d "$expDir" ]; then
   mkdir $expDir
fi

expName=$(awk "NR==4" init_setting)
inpPathHDFS=$(cat init_setting|grep hduser|grep inp)
if [[ $hadoopVersion = "2.7.3" ]]; then
inpSize=$(echo $(echo $(hadoop fs -dus $inpPathHDFS|awk '{print $1}'|paste -sd+ |bc -l)/1000000000|bc)GB)
else
inpSize=$(echo $(echo $(hadoop fs -dus $inpPathHDFS|awk '{print $2}'|paste -sd+ |bc -l)/1000000000|bc)GB)
fi

currExpDir=$(echo "$expName"_"$inpSize"_$(date +%Y_%m_%d_%H_%M_%S))
mkdir $expDir/$currExpDir
./clusterInfo.sh > $expDir/$currExpDir/clusterSummary.txt


#=================== RUN THE CODE


javac -cp ./commons-exec-1.0.jar:. config.java
octave -q sim.m

echo "============================"
echo "Result Summary"
echo "Time taken in Default Configuration"
awk '{print sprintf("%.9f",$NF);}' grad_data.csv |head -1
echo "Time taken in SPSA converged Configuration"
awk '{print sprintf("%.9f",$NF);}' grad_data.csv |tail -1

#./sendToMainMachine.sh
#tail -n 1 grad_data_par_val.csv
cp grad* $expDir/$currExpDir
cp sim.m $expDir/$currExpDir
cp par_info $expDir/$currExpDir
cp init_setting $expDir/$currExpDir
fi
