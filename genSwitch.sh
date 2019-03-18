gradFile="grad_data_par_val.csv"
if [ "$#" -eq 1 ]; then
  #  echo "Using grad file: "$1
    gradFile=$1
fi
rm -f config_val
for i in $(seq 1 $(wc -l config_switch|awk '{print $1}')); do tail -n 1 $gradFile|awk '{print $'$i'}' >> config_val2; done

for i in $(seq 1 $(wc -l config_switch|awk '{print $1}'))
do
type=$(sed ''$i'q;d' par_type)
val=$(sed ''$i'q;d' config_val2)
#echo $val $type
if [[ $type == "f" ]];then 
#echo "float"
printf '%.*f\n' 2 $val >> config_val
else 
#echo "something else"
printf '%.*f\n' 0 $val >> config_val
fi
done

rm -f config_val2

for i in $(paste -d '' config_switch config_val); do echo -n " " "-D"$i; done
