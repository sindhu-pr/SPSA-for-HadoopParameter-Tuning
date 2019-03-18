inpPath="/user/hduser/terasort_input_1GB"
outPath="/user/hduser/tera-out"
jarPath="../hadoopNew/hadoop-examples-1.0.3.jar"
starPath="/home/ubuntu/starfish/bin/"
pattern=""
expName="terasort"
gradFile=""

if [ "$#" -eq 1 ]; then
    echo "==========================="
    echo "Using grad file: "$1
    inpFile=$1
    
    inpPath=$(cat $inpFile|grep input)
    outPath=$(cat $inpFile|grep out)
    jarPath=$(cat $inpFile|grep jar)
	
    expName=$(sed '4q;d' $inpFile)
    if [[ $expName = "grep" ]];then
	pattern="pattern"
    fi

    gradFile=$1"_grad_data_par_val.csv"
fi

echo $gradFile
echo $inpPath
echo $outPath
echo $jarPath
echo $starPath
echo $expName
echo $pattern


hadoop dfs -rmr $outPath

echo "******************DEFAULT*******************"
hadoop jar $jarPath $expName $inpPath $outPath $pattern

sleep 5
hadoop dfs -rmr $outPath

echo "******************SPSA OPTIMIZED *******************"
configSwitches=$(./genSwitch.sh)
hadoop jar $jarPath $expName $configSwitches $inpPath $outPath $pattern

#exit
sleep 5
hadoop dfs -rmr $outPath

echo "******************PROFILING *******************"
$starPath/profile hadoop jar $jarPath $expName $inpPath $outPath $pattern

sleep 5
hadoop dfs -rmr $outPath
if [[ $expName = "grep" ]];then
	lastJobId=$(hadoop job -list all |tail -n 2|headn -n 1|awk '{print $1}')
else
	lastJobId=$(hadoop job -list all |tail -n 1|awk '{print $1}')
fi

#lastJobId="job_201609291714_0003"


echo "******************OPTIMIZED RUN*******************"
$starPath/optimize run $lastJobId hadoop jar $jarPath $expName -Dstarfish.job.optimizer.exclude.parameters="io.sort.mb" $inpPath $outPath $pattern

sleep 5
# Save Time

 if [[ $expName = "grep" ]];then
        count=8;
else
	count=4;
    fi

rm $expName"Time"
for job in $(hadoop job -list all |  grep job_ |awk '{print $1}'|tail -n $count)
do
./oldGetFinishTime.sh $job >> $expName"Time"
done



