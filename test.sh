for i in $(ls Experiments)
do 
echo $i
totlines=$(wc -l Experiments/$i/grad_data.csv |awk '{print $1}'i)
if [[ $totlines -lt 6 ]]; then
echo "Not Valid: "$totlines
rm -rf Experiments/$i
else
echo "Valid: " $totlines
fi
done
