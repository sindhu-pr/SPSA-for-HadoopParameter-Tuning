dir="train_init_settings/"
prodDir="prod_init_settings/"
#for bench in $(ls $dir |grep init_setting_|grep -v csv)
for bench in init_setting_ii init_setting_wordcount init_setting_terasort
do
echo $dir$bench

cp $dir$bench init_setting
sync
./runExp.sh
	for gf in $(ls grad*)
	do
	cp $gf $dir$bench"_"$gf
	cp $gf $prodDir$bench"_"$gf
	done
done

exit

echo "---------------------"
for bench in $(ls $prodDir |grep init_setting_|grep -v csv)
do
#echo $prodDir$bench
./runCompare.sh $prodDir$bench
done
