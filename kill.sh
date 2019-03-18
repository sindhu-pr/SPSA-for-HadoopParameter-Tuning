#!/bin/bash

np=$(jps |grep Child|wc -l)
if [ $np -eq 0 ];
then
	exit
else
kill $( jps | grep "Child"  | awk '{print $1}')
fi
