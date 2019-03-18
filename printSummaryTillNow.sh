echo "Result Summary"
echo "Input Size:"
inpPath=$(cat init_setting |grep '*')
du -h $inpPath|awk '{print $1}'|tail -1
echo "Time taken in Default Configuration"
awk '{print sprintf("%.9f",$NF);}' grad_data.csv |head -1
echo "Time taken in SPSA converged Configuration"
awk '{print sprintf("%.9f",$NF);}' grad_data.csv |tail -1

