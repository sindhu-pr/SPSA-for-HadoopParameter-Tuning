function [delay] = executeHadoopJob(theta)
   preVal = checkSavedResult(theta);

	testMode=0;

        if(preVal==-1)
	        disp("Running the Hadoop Job")

		if(testMode==0)
		%disp("Hadoop JOb NOT running")
		%delay = round(rand(1,1)*1000);
        	system('javac -cp ./commons-exec-1.0.jar:. config.java');
        	system('java -cp ./commons-exec-1.0.jar:. config');
	        delay=load('finishTime');
		else
		parval = load('parameters_val');
		parval
		delay=0;
		for i = 1:length(parval)
			if(mod(i,2)==1)
				delay = delay+1/(parval(i));
			else
				delay = delay+parval(i)*10;
			end

		end
		end	
	
        else
        disp("Using Old Saved Values")
	delay = preVal;
        end
end

