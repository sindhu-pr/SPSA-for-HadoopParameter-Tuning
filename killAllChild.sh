#!/bin/bash

#for node in 192.168.1.170 192.168.1.174 192.168.1.173  192.168.1.172 192.168.1.171 192.168.1.169 192.168.1.236 192.168.1.235 192.168.1.234 192.168.1.233 192.168.1.232 192.168.1.231
#do
#    echo "------------$node---------------start"
#    ssh   root@$node  /root/exp_testing/mysrc_old/kill.sh
#    echo "------------$node---------------end"
#done

#for i in $(seq 1 12)
#do
#np=$(ssh node$i jps |grep Child|wc -l)
#if [ $np -ne 0 ];
#then
#	scp kill.sh node$i:/root
#	ssh node$i chmod +x kill.sh
#	ssh node$i exec /root/kill.sh
#	ssh node$i rm kill.sh
#fi
#done
